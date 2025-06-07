# frozen_string_literal: true

# Planetaloz spider
# engine: prestashop
class PlanetalozSpider < ApplicationSpider
  @name = "planetaloz_spider"
  @store = {
    name: "Planetaloz",
    url: "https://www.planetaloz.cl"
  }
  @start_urls = ["https://www.planetaloz.cl/14-juegos-de-mesa?q=Disponibilidad-En+stock"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url)
    paginate(response, url)
  end

  def paginate(response, url)
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url, data: {})
    nodes = response.css("div#js-product-list article")
    nodes.each { |node| parse_product_node(node, url) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, _url)
    item = {}
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = true # Stock filtered by URL query parameter
    item[:image_url] = get_image_url(node)

    send_item item
  end

  def get_url(node)
    node.at_css(".product-title a")[:href]
  end

  def get_title(node)
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end

  def get_price(node)
    price_node = node.at_css("span.price")
    scan_int(price_node.text)
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  rescue NoMethodError
    nil
  end
end
