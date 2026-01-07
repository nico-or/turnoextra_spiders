# frozen_string_literal: true

# Game of Magic store spider
class GameOfMagicSpider < ApplicationSpider
  @name = "game_of_magic_spider"
  @store = {
    name: "Game of Magic",
    url: "https://www.gameofmagictienda.cl"
  }

  @start_urls = [
    "https://www.gameofmagictienda.cl/collection/juegos-de-mesa",
    "https://www.gameofmagictienda.cl/collection/preventa-juegos-de-mesa",
    "https://www.gameofmagictienda.cl/collection/juegos-a-pedido"
  ]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductCardParser,
    selectors: {
      title: "a[@class='bs-collection__product-info']/h3/text()"
    }
  )
end
