# frozen_string_literal: true

# Top8 store spider
# Engine: bsale.cl
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
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div.bs-collection section.grid__item")
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
    next_page_node = response.at_css("ul.pagination li:last-child a")
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

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    node.at_css("img")["src"].then do |url|
      uri = URI.parse(url)
      uri.query = nil
      uri.to_s
    end
  rescue NoMethodError
    nil
  end
end
