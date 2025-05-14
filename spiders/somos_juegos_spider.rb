# frozen_string_literal: true

# Somos Juegos store spider
# Engine: Shopify + Pinflag
class SomosJuegosSpider < ApplicationSpider
  @name = "somos_juegos_spider"
  @store = {
    name: "Somos Juegos",
    url: "https://www.somosjuegos.cl"
  }
  @start_urls = ["https://www.somosjuegos.cl/collections/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div#filter-results ul.grid li.js-pagination-result")
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

  private

  def paginate(response, url)
    pagination_links = response.css("nav ul.pagination a")
    next_page_link = pagination_links.find { /siguiente/i.match?(it.text) }
    next_page_url = next_page_link[:href]
    return unless next_page_url

    request_to :parse, url: absolute_url(next_page_url, base: url)
  end

  def get_url(node, url)
    absolute_url(node.at_css("p a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("p a").text
  end

  def get_price(node)
    price_node = node.css("strong.price__current")
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.at_css("span.product-label--sold-out").nil?
  end

  def get_image_url(node)
    url = node.at_css("img")["data-src"]
    uri = URI.parse(url)
    uri.query = nil
    uri.scheme = "https"
    uri.to_s
  end
end
