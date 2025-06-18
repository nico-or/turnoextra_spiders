# frozen_string_literal: true

# Play Kingdom store spider
class PlayKingdomSpider < EcommerceEngines::Jumpseller::Spider
  @name = "play_kingdom_spider"
  @store = {
    name: "Play Kingdom",
    url: "https://playkingdom.cl"
  }
  @start_urls = ["https://playkingdom.cl/juegos-de-mesa"]
  @config = {}

  def parse_index(response, url:, data: {})
    listings = response.css("div.row div.product-block")
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def next_page_url(response, url)
    next_page = response.at_css("div.category-pager a:last-child[href]")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

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

  def get_image_url(node)
    super(node, "resize")
  end
end
