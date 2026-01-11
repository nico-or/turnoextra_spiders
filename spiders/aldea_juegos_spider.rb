# frozen_string_literal: true

# Aldea Juegos store spider
class AldeaJuegosSpider < ApplicationSpider
  @name = "aldea_juegos_spider"
  @store = {
    name: "Aldea Juegos",
    url: "https://www.aldeajuegos.cl"
  }
  @start_urls = ["https://www.aldeajuegos.cl/7-juegos-de-mesa?q=Disponibilidad-En+stock"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductCardParser
  )
end
