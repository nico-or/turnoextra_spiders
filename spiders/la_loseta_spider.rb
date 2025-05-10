# frozen_string_literal: true

# La Loseta store spider
# Engine: woocommerce
class LaLosetaSpider < ApplicationSpider
  @name = "la_loseta_spider"
  @store = {
    name: "La Loseta",
    url: "https://laloseta.cl/"
  }
  @start_urls = ["https://laloseta.cl/catalogo/swoof1/product_cat-juego-de-mesa/instock/"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("ul.products li.product")
    listings.each { parse_product_node(it) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = true # Stock filtered by URL parameter "instock"

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.at_css("nav.woocommerce-pagination li a.next")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node)
    node.at_css("a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    # TODO: verify how a discounted listings prices are displayed.
    price_node = node.css("span.price bdi").last
    scan_int(price_node.text) if price_node
  end
end
