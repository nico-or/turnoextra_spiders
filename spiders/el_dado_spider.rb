# frozen_string_literal: true

# El Dado store spider
class ElDadoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "el_dado_spider"
  @store = {
    name: "El Dado",
    url: "https://eldado.cl"
  }
  @start_urls = ["https://eldado.cl/catalogo-de-juegos"]
  @config = {}

  def parse_index(response, url:, data: {})
    listings = response.css("div.product-grid-items div.product-type-simple")
    listings.map { |listing| parse_product_node(listing, url:) }
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
