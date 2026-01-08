# frozen_string_literal: true

# Chucao Juegos store spider
class ChucaoJuegosSpider < ApplicationSpider
  @name = "chucao_juegos_spider"
  @store = {
    name: "Chucao Juegos",
    url: "https://www.chucaojuegos.cl/"
  }
  @start_urls = ["https://www.chucaojuegos.cl/catalogo-completo"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser
  )
end
