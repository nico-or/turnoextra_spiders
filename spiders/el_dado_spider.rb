# frozen_string_literal: true

# El Dado store spider
# engine: woocomerce
class ElDadoSpider < ApplicationSpider
  @name = "el_dado_spider"
  @store = {
    name: "El Dado",
    url: "https://eldado.cl"
  }
  @start_urls = ["https://eldado.cl/catalogo-de-juegos"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div.product-grid-items div.product-type-simple")
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
    node.at_css("h2").text.strip
  end

  def get_price(node)
    price_node = node.css("span.price bdi").last
    # somehow there are no prices on some items...
    # ex: https://eldado.cl/producto/dobble-31-minutos/ (10/05/2025)
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.classes.include?("instock")
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    # Example: https://eldado.cl/wp-content/uploads/2024/09/pw-gift-card-150x150.png
    full_url = node.at_css("img")["src"]
    match = full_url.match(/(?<base>.+?)(?<size>-\d+x\d+)?(?<ext>\.\w+)$/)
    return unless match

    "#{match[:base]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
