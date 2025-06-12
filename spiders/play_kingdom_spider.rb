# frozen_string_literal: true

# Play Kingdom store spider
# engine: jumpseller
class PlayKingdomSpider < ApplicationSpider
  @name = "play_kingdom_spider"
  @store = {
    name: "Play Kingdom",
    url: "https://playkingdom.cl"
  }
  @start_urls = ["https://playkingdom.cl/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url:)
    paginate(response, url:)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url:, data: {})
    nodes = response.css("div.row div.product-block")
    nodes.each { |node| parse_product_node(node, url:) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url:)
    item = {}

    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node)

    send_item item
  end

  def paginate(response, url:)
    next_page = response.css("div.category-pager a").last
    return unless next_page[:href]

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node, url)
    rel_url = node.at_css("a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h3 a")[:title]
  end

  def get_price(node)
    price_node = node.css("div.list-price span").first
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css("a").classes.include?("not-available")
  end

  def get_image_url(node)
    # example: https://cdnx.jumpseller.com/play-kingdom/image/30309479/resize/300/300?1671209307
    node.at_css("img")[:src].split("/resize").first
  rescue NoMethodError
    nil
  end
end
