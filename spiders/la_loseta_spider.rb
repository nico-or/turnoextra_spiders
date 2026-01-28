# frozen_string_literal: true

# La Loseta store spider
class LaLosetaSpider < ApplicationSpider
  @name = "la_loseta_spider"
  @store = {
    name: "La Loseta",
    url: "https://laloseta.cl/"
  }
  @start_urls = ["https://laloseta.cl/catalogo/swoof1/product_cat-juego-de-mesa/instock/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
