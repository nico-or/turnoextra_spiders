# frozen_string_literal: true

# El Dado store spider
class ElDadoSpider < ApplicationSpider
  @name = "el_dado_spider"
  @store = {
    name: "El Dado",
    url: "https://eldado.cl"
  }
  @start_urls = ["https://eldado.cl/catalogo-de-juegos"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.product-grid-items div.product-type-simple"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
