# frozen_string_literal: true

# Aldea Juegos store spider
# engine: prestashop
class AldeaJuegosSpider < ApplicationSpider
  @name = "aldea_juegos_spider"
  @store = {
    name: "Aldea Juegos",
    url: "https://www.aldeajuegos.cl"
  }
  @start_urls = ["https://www.aldeajuegos.cl/7-juegos-de-mesa?q=Disponibilidad-En+stock"]
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
    item[:stock] = true # Stock filtered by URL query parameter

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
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end

  def get_price(node)
    price_node = node.css("span.price").last
    scan_int(price_node.text)
  end
end
