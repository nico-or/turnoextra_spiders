# frozen_string_literal: true

# Enroque store spider
# Engine: shopify
class EnroqueSpider < ApplicationSpider
  @name = "enroque_spider"
  @store = {
    name: "enroque",
    url: "https://www.juegosenroque.cl/"
  }
  @start_urls = ["https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div#filter-results li.js-pagination-result")
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
    next_page = response.css("ul.pagination li a").last
    # last page has the <a> element, but it doesn't have the href attribute
    return unless next_page[:href]

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def get_url(node, url)
    absolute_url(node.at_css("a.card-link")[:href], base: url)
  end

  def get_title(node)
    node.at_css("a.card-link").text
  end

  def get_price(node)
    price_node = node.at_css("strong.price__current")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    # Posible values: 'Preventa', 'Agregar al carrito'
    button_text = node.at_css("button span").text.strip.downcase

    # Posible values: 'disabled', nil
    button_disabled = node.at_css("button")[:disabled]

    button_text.match?("carrito") && !button_disabled
  end

  def get_image_url(node)
    url = node.at_css("img")["data-src"]
    uri = URI.parse(url)
    uri.query = nil
    uri.scheme = "https"
    uri.to_s
  rescue NoMethodError
    nil
  end
end
