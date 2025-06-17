# frozen_string_literal: true

# Diverti store spider
# engine: Prestashop
class DivertiSpider < ApplicationSpider
  @name = "diverti_spider"
  @store = {
    name: "Diverti",
    url: "https://www.diverti.cl/"
  }
  @start_urls = ["https://www.diverti.cl/juegos-de-mesa-16?en-stock=1"]
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
    # This store doesn't disable the next page link on the last pagination result
    next_page_node = response.at_css("nav.pagination li a[rel=next]")
    return if next_page_node.nil? || next_page_node.classes.include?("disabled")

    absolute_url(next_page_node[:href], base: url)
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
    node.at_css(".product-title").text.strip
  end

  def get_price(node)
    price_node = node.at_css("span.price")
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.at_css("div.ago").text.empty?
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
