# frozen_string_literal: true

# La Teka store spider
# engine: Shopify
class LaTekaSpider < ApplicationSpider
  @name = "la_teka_spider"
  @store = {
    name: "La Teka",
    url: "https://lateka.cl"
  }
  @start_urls = ["https://lateka.cl/collections/juegos-de-mesa?filter.v.availability=1"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("ul#product-grid div.card")
    listings.each { parse_product_node(it, url) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url)
    item = {}
    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node)

    send_item item
  end

  def paginate(response, url)
    # yes, the store has backward styles for next and prev links...
    next_page = response.at_css("nav.pagination a.pagination__item--prev")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def get_url(node, url)
    rel_url = node.at_css("h3 a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h3").text.strip
  end

  def get_price(node)
    price_node = node.at_css("span.price-item--sale")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    add_to_cart_button = node.at_css("product-form button")
    add_to_cart_button["disabled"].nil?
  end

  def get_image_url(node)
    url = node.at_css("img")["src"]
    uri = URI.parse(url)
    uri.scheme = "https"
    uri.query = nil
    uri.to_s
  rescue NoMethodError
    nil
  end
end
