# frozen_string_literal: true

# Piedrabruja store spider
# Engine: shopify
#
# This store serves malformed HTML.
# Many tags aren't closed properly, which causes each listing node to include all subsequent nodes.
# Thus it's necessary to use only #at_css to find the first tag that matches the selector.
# This also causes that we can't easily drop the empty placeholders nodes at the end of the listings array.
#
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
    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = true
    item[:image_url] = get_image_url(node)

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.css("a").find { it.text.include?("más productos") }
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node, url)
    absolute_url(node.at_css("h3 a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("h3").text
  end

  def get_price(node)
    price_node = node.at_css("p.price/text()")
    scan_int(price_node.text)
  end

  # Since the store has empty nodes at the end of the HTML,
  # we need to rescue from errors when trying to access the :src attribute.
  def get_image_url(node)
    url = node.at_css("img")["src"]
    uri = URI.parse(url)
    uri.scheme = "https"
    uri.query = nil
    uri.to_s
  rescue StandardError
    nil
  end
end
