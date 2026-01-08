# frozen_string_literal: true

# Lautaro Juegos store spider
class LautaroJuegosSpider < ApplicationSpider
  @name = "lautaro_juegos_spider"
  @store = {
    name: "Lautaro Juegos",
    url: "https://www.lautarojuegos.cl/"
  }
  @start_urls = ["https://www.lautarojuegos.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser,
    selectors: {
      next_page: "div.category-pager a:last-child[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::LaTribuGames::ProductCardParser
  )
end
