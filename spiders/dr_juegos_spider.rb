# frozen_string_literal: true

# Dr. Juegos store spider
class DrJuegosSpider < ApplicationSpider
  @name = "dr_juegos_spider"
  @store = {
    name: "Dr. Juegos",
    url: "https://www.drjuegos.cl"
  }
  @start_urls = ["https://www.drjuegos.cl/2-todos-los-productos?q=Disponibilidad-En+stock"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser
  )
  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductCardParser,
    selectors: {
      title: "h5",
      stock: "div.product-availability span.unavailable",
      url: "h5 a"
    }
  )
end
