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
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div#filter-results li.js-pagination-result")
    listings.each { parse_product_node(it) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = absolute_url(node.at_css("a.card-link")[:href], base: self.class.store[:url])
    item[:title] = node.at_css("a.card-link").text
    item[:price] = node.at_css("strong.price__current").text.then { scan_int(it) }
    item[:stock] = in_stock?(node)

    send_item item
  end

  def paginate(response, url)
    next_page = response.css("ul.pagination li a").last
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def in_stock?(node)
    # Posible values: 'Preventa', 'Agregar al carrito'
    button_text = node.at_css("button span").text.strip.downcase

    # Posible values: 'disabled', nil
    button_disabled = node.at_css("button")[:disabled]

    button_text.match?("carrito") && !button_disabled
  end
end
