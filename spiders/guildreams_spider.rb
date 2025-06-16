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
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div.bs-product")
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def parse_product_node(node, url:)
    {
      url: get_url(node, url),
      title: get_title(node),
      price: get_price(node),
      stock: purchasable?(node),
      image_url: get_image_url(node)
    }
  end

  def next_page_url(response, url)
    navigation_nodes = response.css("ul.pagination a.page-link")
    next_page_node = navigation_nodes.select { |n| n["data-nf"] }.last # data-nf marks arrow (prev, next) links
    return unless next_page_node

    absolute_url(next_page_node[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    rel_url = node.at_css("a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def get_price(node)
    price_node = node.at_css("div.bs-product-final-price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    node.at_css("div.bs-stock").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    node.at_css("img")["data-src"].then do |url|
      uri = URI.parse(url)
      uri.query = nil
      uri.to_s
    end
  rescue NoMethodError
    nil
  end
end
