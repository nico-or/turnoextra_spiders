# frozen_string_literal: true

# Planetaloz spider
# engine: prestashop
class PlanetalozSpider < ApplicationSpider
  @name = "planetaloz_spider"
  @store = {
    name: "Planetaloz",
    url: "https://www.planetaloz.cl"
  }
  @start_urls = ["https://www.planetaloz.cl/14-juegos-de-mesa?q=Disponibilidad-En+stock"]
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
    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node)
    node.at_css(".product-title a")[:href]
  end

  def get_title(node)
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end

  def get_price(node)
    price_node = node.at_css("span.price")
    scan_int(price_node.text)
  end

  def purchasable?(_node)
    # filtered with query parameters
    true
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  rescue NoMethodError
    nil
  end
end
