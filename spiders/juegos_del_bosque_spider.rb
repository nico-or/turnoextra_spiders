# frozen_string_literal: true

# Juegos Del Bosque store spider
class JuegosDelBosqueSpider < ApplicationSpider
  @name = "juegos_del_bosque_spider"
  @store = {
    name: "Juegos Del Bosque",
    url: "https://www.juegosdelbosque.cl/"
  }
  @start_urls = ["https://www.juegosdelbosque.cl/juego-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      stock: "div.product-block__label--status"
    }
  )
end
