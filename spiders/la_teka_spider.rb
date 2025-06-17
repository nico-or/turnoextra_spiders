# frozen_string_literal: true

# La Teka store spider
# engine: Shopify
class LaTekaSpider < ApplicationSpider
  @name = "la_teka_spider"
  @store = {
    name: "La Teka",
    url: "https://lateka.cl"
  }
  @start_urls = ["https://lateka.cl/collections/juegos-de-mesa?filter.v.availability=1"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("ul#product-grid div.card")
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
    # yes, the store has backward styles for next and prev links...
    next_page = response.at_css("nav.pagination a.pagination__item--prev")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    rel_url = node.at_css("h3 a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h3").text.strip
  end

  def get_price(node)
    price_node = node.at_css("span.price-item--sale")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    node.at_css("product-form button")["disabled"].nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    url = node.at_css("img")["src"]
    uri = URI.parse(url)
    uri.scheme = "https"
    uri.query = nil
    uri.to_s
  rescue NoMethodError
    nil
  end
end
