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
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div.row div.product-block")
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
    next_page = response.at_css("div.category-pager a:last-child[href]")
    return unless next_page

    absolute_url(next_page[:href], base: url)
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
    node.at_css("h3 a")[:title]
  end

  def get_price(node)
    price_node = node.at_css("div.list-price span:first-child")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css("form button").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    # example: https://cdnx.jumpseller.com/play-kingdom/image/30309479/resize/300/300?1671209307
    node.at_css("img")[:src].split("/resize").first
  rescue NoMethodError
    nil
  end
end
