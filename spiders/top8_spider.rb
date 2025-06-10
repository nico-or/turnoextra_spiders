# frozen_string_literal: true

# Top8 store spider
# engine: ?
class Top8Spider < ApplicationSpider
  @name = "top8_spider"
  @store = {
    name: "Top8",
    url: "https://www.top8.cl"
  }

  # Clicking 'show all' doesn't show all games,
  # so we need to crawl each collection individually
  @start_urls = [
    "https://www.top8.cl/collection/juegos-de-mesa",
    "https://www.top8.cl/collection/jm-eurogames",
    "https://www.top8.cl/collection/jm-party-games",
    "https://www.top8.cl/collection/jm-deck-building",
    "https://www.top8.cl/collection/jm-infantiles",
    "https://www.top8.cl/collection/jm-draft",
    "https://www.top8.cl/collection/jm-fillers",
    "https://www.top8.cl/collection/jm-cooperativos",
    "https://www.top8.cl/collection/jm-rol",
    "https://www.top8.cl/collection/dungeons-dragons"
  ]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url:, data: {})
    nodes = response.css("div.bs-collection section.grid__item")
    nodes.each { |node| parse_product_node(node, url) }
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
    next_page = response.at_css("ul.pagination li:last-child a")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  private

  def get_url(node, url)
    rel_url = node.at_css("a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("a")[:title]
  end

  def get_price(node)
    price_node = node.at_css("div.bs-collection__product-final-price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    # only present in out-of-stock items
    node.at_css("div.bs-collection__stock").nil?
  end

  def get_image_url(node)
    node.at_css("img")["src"]
  rescue NoMethodError
    nil
  end
end
