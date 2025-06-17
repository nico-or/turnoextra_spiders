# frozen_string_literal: true

# Magicsur store spider
# Engine: prestashop
class MagicsurSpider < ApplicationSpider
  @name = "magicsur_spider"
  @store = {
    name: "magicsur",
    url: "https://www.magicsur.cl/"
  }
  @start_urls = ["https://www.magicsur.cl/15-juegos-de-mesa-magicsur-chile"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div#js-product-list article")
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def parse_product_node(node, url:)
    {
      url: get_url(node),
      title: get_title(node),
      price: get_price(node),
      stock: purchasable?(node),
      image_url: get_image_url(node)
    }
  end

  def next_page_url(response, url)
    next_page_node = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page_node

    absolute_url(next_page_node[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node)
    node.at_css("h2 a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def get_price(node)
    price_node = node.at_css("span.product-price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css("form button.add-to-cart").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  rescue NoMethodError
    nil
  end
end
