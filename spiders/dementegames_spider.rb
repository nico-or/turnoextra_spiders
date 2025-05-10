# frozen_string_literal: true

# Demente Games store spider
# engine: Prestashop
class DementegamesSpider < ApplicationSpider
  @name = "dementegames_spider"
  @store = {
    name: "Demente Games",
    url: "https://www.dementegames.cl/"
  }
  @start_urls = ["https://dementegames.cl/10-juegos-de-mesa?page=1&q=Disponibilidad-Inmediata/Existencias-En+stock"]
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

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node)
    node.at_css(".product-title a")[:href]
  end

  def get_title(node)
    node.at_css(".product-title").text
  end

  def get_price(node)
    node.at_css("span.price")[:content].to_i
  end
end
