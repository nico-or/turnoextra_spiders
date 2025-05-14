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
    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node)

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.at_css("ul.pager li.next a")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node, url)
    absolute_url(node.at_css("h2 a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    price_node = node.at_css("div.product-block__price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    node.at_css(".product-block__actions form") != nil
  end

  def get_image_url(node)
    node.at_css("img")["src"].split("/resize/").first
  end
end
