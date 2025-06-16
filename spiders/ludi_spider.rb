# frozen_string_literal: true

# Ludi store spider
# Engine: woocommerce
class LudiSpider < ApplicationSpider
  @name = "ludi_spider"
  @store = {
    name: "Ludi",
    url: "https://www.ludi.cl"
  }
  @start_urls = ["https://www.ludi.cl/tienda"]
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
    next_url = next_page_url(response, url)
    request_to(:parse, url: next_url) if next_url
  end

  def get_url(node)
    node.at_css("a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def get_price(node)
    price_node = node.css("span.price bdi").last
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.classes.include?("instock")
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    # Example: https://www.ludi.cl/wp-content/uploads/2025/04/00-8-300x300.jpg
    full_url = node.at_css("img")["src"]
    match = full_url.match(/(?<url>.*)(?<size>-\d+x\d+)(?<ext>\..*)/)
    return unless match

    "#{match[:url]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
