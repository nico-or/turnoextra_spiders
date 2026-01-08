# frozen_string_literal: true

# La Tribu Games store spider
class LaTribuGamesSpider < ApplicationSpider
  @name = "la_tribu_games_spider"
  @store = {
    name: "La Tribu Games",
    url: "https://latribugames.cl/"
  }
  @start_urls = ["https://latribugames.cl/juegos-de-mesa"]

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
