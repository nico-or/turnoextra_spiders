# frozen_string_literal: true

# Kaio Juegos store spider
class KaioJuegosSpider < ApplicationSpider
  @name = "entrejuegos_spider"
  @name = "kaio_juegos_spider"
  @store = {
    name: "Kaio Juegos",
    url: "https://kaiojuegos.cl/"
  }
  @start_urls = ["https://kaiojuegos.cl/18-juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductCardParser
  )
end
