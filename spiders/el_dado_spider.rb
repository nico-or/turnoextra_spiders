# frozen_string_literal: true

# El Dado store spider
# engine: woocomerce
class ElDadoSpider < ApplicationSpider
  @name = "el_dado_spider"
  @store = {
    name: "El Dado",
    url: "https://eldado.cl"
  }
  @start_urls = ["https://eldado.cl/catalogo-de-juegos"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div.product-grid-items div.product-type-simple")
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

  def paginate(response, url)
    next_page = response.at_css("nav.woocommerce-pagination a.next")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def get_url(node)
    node.at_css("a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def in_stock?(node)
    node.classes.include?("instock")
  end

  def get_price(node)
    price_node = node.css("span.price bdi").last
    # somehow there are no prices on some items...
    # ex: https://eldado.cl/producto/dobble-31-minutos/ (10/05/2025)
    scan_int(price_node.text) if price_node
  end

  def get_image_url(node)
    node.at_css("img")[:src]
  end
end
