# frozen_string_literal: true

# Entrejuegos  store spider
# engine: prestashop
class EntrejuegosSpider < ApplicationSpider
  @name = "entrejuegos_spider"
  @store = {
    name: "Entrejuegos",
    url: "https://www.entrejuegos.cl/"
  }
  @start_urls = ["https://www.entrejuegos.cl/1064-juegos-de-mesa?page=1"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url: nil, data: {})
    listings = response.css("div#js-product-list article")
    listings.map { |listing| parse_product_node(listing) }
  end

  def parse_product_node(node, url: nil)
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
    node.at_css(".product-title a")[:href]
  end

  def get_title(node)
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end

  def get_price(node)
    price_node = node.at_css("span.price")
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    out_of_stock_banner = node.at_css("li.out_of_stock")
    out_of_stock_banner.nil?
  end

  def price?(node)
    # example: https://www.entrejuegos.cl/juegos-de-mesa/16717-everdell-spirecrest.html
    # sometimes listings appear in the index but don't have a price element
    # when that happens, the 'add to cart' button is also disabled
    # this is different from products marked as 'out of stock'
    # which have a price tag element
    price_node = node.at_css("span.price")
    !price_node.nil?
  end

  def purchasable?(node)
    in_stock?(node) && price?(node)
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  rescue NoMethodError
    nil
  end
end
