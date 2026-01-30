# frozen_string_literal: true

# Jugones store spider
class JugonesSpider < ApplicationSpider
  @name = "jugones_spider"
  @store = {
    name: "Jugones",
    url: "https://www.jugones.cl/"
  }
  @start_urls = ["https://www.jugones.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    Stores::Jugones::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Jugones::ProductCardParser
  )
end
