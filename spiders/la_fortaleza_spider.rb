# frozen_string_literal: true

# La Fortaleza store spider
# engine: jumpseller
class LaFortalezaSpider < ApplicationSpider
  @name = "la_fortaleza_spider"
  @store = {
    name: "La Fortaleza",
    url: "https://www.lafortalezapuq.cl"
  }
  @start_urls = ["https://www.lafortalezapuq.cl/jdm"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url:)
    paginate(response, url:)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url:, data: {})
    nodes = response.css("div.products figure.product")
    nodes.each { |node| parse_product_node(node, url:) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url:)
    item = {}

    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node)

    send_item item
  end

  def paginate(response, url:)
    next_page = response.at_css("nav.pagination-next-prev a[@class=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node, url)
    rel_url = node.at_css("a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h5").text
  end

  def get_price(node)
    discount_node = node.at_css("span.product-price-discount i")
    regular_node = node.at_css("span.product-price")
    price_node = discount_node || regular_node
    scan_int(price_node.text)
  end

  def in_stock?(_node)
    true
  end

  def get_image_url(node)
    # example: https://cdnx.jumpseller.com/la-fortaleza-punta-arenas1/image/13909331/thumb/230/260?1610821805
    node.at_css("img")[:src].split("/thumb").first
  rescue NoMethodError
    nil
  end
end
