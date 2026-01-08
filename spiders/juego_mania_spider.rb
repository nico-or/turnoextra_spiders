# frozen_string_literal: true

# Juego Mania store spider
class JuegoManiaSpider < ApplicationSpider
  @name = "juego_mania_spider"
  @store = {
    name: "Juego Mania",
    url: "https://www.juegomania.cl/"
  }
  @start_urls = ["https://www.juegomania.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      stock: "div.product-block__label--status",
      price: "div.product-block__price--new,
      div.product-block__price:last-child,
      div.product-block__price span:first-child"
    }
  )
end
