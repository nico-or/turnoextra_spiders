# frozen_string_literal: true

# Revaruk store spider
# Engine: woocommerce
class RevarukSpider < ApplicationSpider
  @name = "revaruk_spider"
  @store = {
    name: "Revaruk",
    url: "https://revaruk.cl"
  }
  @start_urls = ["https://revaruk.cl/product-category/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div.ast-woocommerce-container ul.products li.product")
    listings.each { parse_product_node(it) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node)

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.at_css("nav.woocommerce-pagination li a.next")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node)
    node.at_css("div.astra-shop-summary-wrap a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    price_node = node.css("span.price bdi").last
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.classes.include?("instock")
  end

  def get_image_url(node)
    node.at_css("img")["data-srcset"].split(", ").last.split.first
  rescue NoMethodError
    nil
  end
end
