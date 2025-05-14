# frozen_string_literal: true

# Diverti store spider
# engine: Prestashop
class DivertiSpider < ApplicationSpider
  @name = "diverti_spider"
  @store = {
    name: "Diverti",
    url: "https://www.diverti.cl/"
  }
  @start_urls = ["https://www.diverti.cl/juegos-de-mesa-16?en-stock=1"]
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

  # parse a Nokogiri node and return an item
  def parse_product_node(node)
    item = {}
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = true # Stock filtered by URL query parameter
    item[:image_url] = get_image_url(node)

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def get_url(node)
    node.at_css(".product-title a")[:href]
  end

  def get_title(node)
    node.at_css(".product-title").text
  end

  def get_price(node)
    price_node = node.at_css("span.price")
    scan_int(price_node.text) if price_node
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  end
end
