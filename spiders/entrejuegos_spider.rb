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
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_price(node)
    return unless in_stock?(node)

    price_node = node.at_css("span.price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    price_node = node.at_css("span.price")
    !price_node.nil?
  end
end
