# frozen_string_literal: true

# Entrejuegos  store spider
# engine: prestashop
class EntrejuegosSpider < ApplicationSpider
  @name = "entrejuegos_spider"
  @store = {
    name: "Entrejuegos",
    url: "https://www.entrejuegos.cl/"
  }
  @start_urls = ["https://www.entrejuegos.cl/1064-juegos-de-mesa?page=1"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div#js-product-list article")
    listings.each { parse_product_node(it) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = node.at_css(".product-title a")[:href]
    item[:title] = node.at_css(".product-title").text
    # The price element is mising for out-of-stock products
    price_node = node.at_css("span.price")
    item[:price] = price_node.nil? ? 0 : scan_int(price_node.text)
    item[:stock] = !price_node.nil?
    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  # TODO: Fetch a product page when the title is truncated in the index
  # TODO: check if full title was already scrapped before fetching a product page
  # (to reduce the total amount of webrequests)

  def parse_product_page(response, url:, data: {})
    item = {}
    item[:url] = url
    item[:title] = response.at_css("h1").text
    # The price element is mising for out-of-stock products
    node = response.at_css("div.current-price span.current-price-value")
    item[:price] = node.nil? ? 0 : node["content"].to_i
    item[:stock] = !node.nil?
    send_item item
  end

  def should_follow(article)
    if article.at_css(".product-title").text.end_with?("...")
      link = article.at_css(".product-title a")
      request_to :parse_product_page, url: absolute_url(link[:href], base: url)
    else
      parse_product_node(article)
    end
  end
end
