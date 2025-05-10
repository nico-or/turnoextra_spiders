# frozen_string_literal: true

# Devir store spider
# engine: ??
class DevirSpider < ApplicationSpider
  @name = "devir_spider"
  @store = {
    name: "Devir",
    url: "https://www.devir.cl/"
  }
  @start_urls = ["https://devir.cl/juegos-de-mesa?p=1"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div.products li.item")
    listings.each { parse_product_node(it) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css('a[title="Siguiente"]')
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def in_stock?(node)
    button_node = node.css("div.actions-primary")
    button_text = button_node.text.strip
    button_text.eql?("Añadir al carrito")
  end

  def get_url(node)
    node.at_css("strong a")[:href]
  end

  def get_title(node)
    node.at_css("strong a").text.strip
  end

  # parses prices in the format 12.990,00 CLP
  def get_price(node)
    price_text = node.at_css("span.price")&.text&.strip
    return unless price_text

    sanitized_price = price_text.sub(/,00.+/, "")
    scan_int(sanitized_price)
  end
end
