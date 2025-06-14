# frozen_string_literal: true

# Dr. Juegos store spider
# engine: prestashop
class DrJuegosSpider < ApplicationSpider
  @name = "dr_juegos_spider"
  @store = {
    name: "Dr. Juegos",
    url: "https://www.drjuegos.cl"
  }
  @start_urls = ["https://www.drjuegos.cl/2-todos-los-productos?q=Disponibilidad-En+stock"]
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
    node.at_css("h5 a")[:href]
  end

  def get_title(node)
    node.at_css("h5").text.strip
  end

  def get_price(node)
    price_node = node.css("span.price").last
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css("button.add-to-cart").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    node.at_css("img")[:src].sub("home_default", "large_default")
  rescue NoMethodError
    nil
  end
end
