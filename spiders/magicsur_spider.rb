# frozen_string_literal: true

# Magicsur store spider
# Engine: prestashop
class MagicsurSpider < ApplicationSpider
  @name = "magicsur_spider"
  @store = {
    name: "magicsur",
    url: "https://www.magicsur.cl/"
  }
  @start_urls = ["https://www.magicsur.cl/15-juegos-de-mesa-magicsur-chile"]
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
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = true
    item[:image_url] = get_image_url(node)

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node)
    node.at_css("h2 a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    price_node = node.at_css("span.product-price")
    scan_int(price_node.text)
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  rescue NoMethodError
    nil
  end
end
