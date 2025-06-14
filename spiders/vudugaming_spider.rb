# frozen_string_literal: true

# VuduGaming store spider
# Engine: jumpseller
class VudugamingSpider < ApplicationSpider
  @name = "vudugaming_spider"
  @store = {
    name: "VuduGaming",
    url: "https://www.vudugaming.cl/"
  }
  @start_urls = ["https://www.vudugaming.cl/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("article.product-block")
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
    next_page = response.at_css("ul.pager li.next a")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    absolute_url(node.at_css("h2 a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def get_price(node)
    price_node = node.at_css("div.product-block__price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css(".product-block__actions form").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    node.at_css("img")["src"].split("/resize/").first
  rescue NoMethodError
    nil
  end
end
