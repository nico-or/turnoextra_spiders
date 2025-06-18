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

  image_url_strategy(:sized)
end
