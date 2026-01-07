# frozen_string_literal: true

# Tienda Card Game store spider
class TiendaCardGameSpider < ApplicationSpider
  @name = "tienda_card_game_spider"
  @store = {
    name: "Tienda Card Game",
    url: "https://www.cardgame.cl/"
  }
  @start_urls = ["https://www.cardgame.cl/collection/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductCardParser
  )
end
