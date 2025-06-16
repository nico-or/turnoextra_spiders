# frozen_string_literal: true

# Enroque store spider
# Engine: shopify
class EnroqueSpider < ApplicationSpider
  @name = "enroque_spider"
  @store = {
    name: "enroque",
    url: "https://www.juegosenroque.cl/"
  }
  @start_urls = ["https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div#filter-results li.js-pagination-result")
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
    next_page = response.at_css("nav ul.pagination li:last-child a")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    absolute_url(node.at_css("a.card-link")[:href], base: url)
  end

  def get_title(node)
    node.at_css("a.card-link").text
  end

  def get_price(node)
    price_node = node.at_css("strong.price__current")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    # Posible values: 'Preventa', 'Agregar al carrito'
    button_text = node.at_css("button span").text.strip.downcase

    # Posible values: 'disabled', nil
    button_disabled = node.at_css("button")[:disabled]

    button_text.match?("carrito") && !button_disabled
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
