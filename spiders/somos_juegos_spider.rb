# frozen_string_literal: true

# Somos Juegos store spider
# Engine: Shopify + Pinflag
class SomosJuegosSpider < ApplicationSpider
  @name = "somos_juegos_spider"
  @store = {
    name: "Somos Juegos",
    url: "https://www.somosjuegos.cl"
  }
  @start_urls = ["https://www.somosjuegos.cl/collections/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div#filter-results ul.grid li.js-pagination-result")
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
    pagination_links = response.css("nav ul.pagination a")
    next_page = pagination_links.find { /siguiente/i.match?(it.text) }
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    absolute_url(node.at_css("p a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("p a").text
  end

  def get_price(node)
    price_node = node.css("strong.price__current")
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.at_css("span.product-label--sold-out").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    url = node.at_css("img")["data-src"]
    uri = URI.parse(url)
    uri.query = nil
    uri.scheme = "https"
    uri.to_s
  rescue NoMethodError
    nil
  end
end
