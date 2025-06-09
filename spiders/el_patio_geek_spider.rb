# frozen_string_literal: true

# El Patio Geek store spider
# Engine: shopify
class ElPatioGeekSpider < ApplicationSpider
  @name = "el_patio_geek_spider"
  @store = {
    name: "El Patio Geek",
    url: "https://www.elpatiogeek.cl/"
  }
  @start_urls = ["https://www.elpatiogeek.cl/collections/all"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    nodes = response.css("div.grid-uniform div.grid-item")
    nodes.each { |node| parse_product_node(node, url) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url)
    item = {}
    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node, url)

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("ul.pagination-custom li:last-child a")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node, url)
    absolute_url(node.at_css("a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("p").text
  end

  def get_price(node)
    price_node = node.at_css("div.product-item--price small")
    scan_int(price_node&.text)
  end

  def in_stock?(_node)
    true
  end

  def get_image_url(node, url)
    image_url = node.css("img").last["srcset"].split[-2]
    absolute_url(image_url, base: url)
  rescue NoMethodError
    nil
  end
end
