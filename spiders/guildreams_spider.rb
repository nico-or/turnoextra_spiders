# frozen_string_literal: true

# Guildreams store spider
# engine: ?
class GuildreamsSpider < ApplicationSpider
  @name = "guildreams_spider"
  @store = {
    name: "Guildreams",
    url: "https://www.guildreams.com"
  }
  @start_urls = ["https://www.guildreams.com/collection/juegos-de-mesa?order=id&way=DESC&limit=24&page=1"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div.bs-product")
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
    navigation_nodes = response.css("ul.pagination a.page-link")
    next_page = navigation_nodes.select { |n| n["data-nf"] }.last # data-nf marks arrow (prev, next) links
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def get_url(node, url)
    rel_url = node.at_css("a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    price_node = node.at_css("div.bs-product-final-price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    button = node.at_css("button")
    !button.text.match?(/agotado/i)
  end

  def get_image_url(node)
    node.at_css("img")["data-src"]
  rescue NoMethodError
    nil
  end
end
