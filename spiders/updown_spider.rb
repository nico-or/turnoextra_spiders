# frozen_string_literal: true

# Updown store spider
# Engine: woocommerce
class UpdownSpider < ApplicationSpider
  @name = "updown_spider"
  @store = {
    name: "Updown",
    url: "https://www.updown.cl/"
  }
  @start_urls = ["https://www.updown.cl/categoria-producto/juegos-de-mesa/"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("ul.products li.product")
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
    next_page = response.at_css("nav.woocommerce-pagination li a.next")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node)
    node.at_css("a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    price_node = node.css("span.price bdi").last
    scan_int(price_node.text)
  end

  def purchasable?(_node)
    true
  end

  def get_image_url(node)
    node.at_css("img")["srcset"].split(", ").last.split.first
  rescue NoMethodError
    nil
  end
end
