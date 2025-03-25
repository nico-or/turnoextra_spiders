# frozen_string_literal: true

# VuduGaming store spider
# Engine: jumpseller
class VudugamingSpider < ApplicationSpider
  @name = "vudugaming_spider"
  @store = {
    name: "VuduGaming",
    url: "https://www.vudugaming.cl/"
  }
  @start_urls = ["https://www.vudugaming.cl/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("article.product-block")
    listings.each { parse_product_node(it, url) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url)
    item = {}
    item[:url] = absolute_url(node.at_css("h2 a")[:href], base: url)
    item[:title] = node.at_css("h2").text
    item[:price] = scan_int(node.at_css("div.product-block__price").text)
    item[:stock] = true

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("ul.pager li.next a")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end
end
