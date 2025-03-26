# frozen_string_literal: true

# Piedrabruja store spider
# Engine: shopify
class PiedrabrujaSpider < ApplicationSpider
  @name = "piedrabruja_spider"
  @store = {
    name: "piedrabruja",
    url: "https://www.piedrabruja.cl/"
  }
  @start_urls = ["https://piedrabruja.cl/collections/juegos-de-mesa?page=1"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("ul#collection li.product-card")
    listings.each { parse_product_node(it, url) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url)
    item = {}
    item[:url] = absolute_url(node.at_css("h3 a")[:href], base: url)
    item[:title] = node.at_css("h3").text
    item[:price] = get_price(node)
    item[:stock] = true

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.css("a").find { it.text.include?("más productos") }
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_price(node)
    price_node = node.at_css("p.price")
    scan_int(price_node.text)
  end
end
