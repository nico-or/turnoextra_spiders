# frozen_string_literal: true

# Play Kingdom store spider
class PlayKingdomSpider < ApplicationSpider
  @name = "play_kingdom_spider"
  @store = {
    name: "Play Kingdom",
    url: "https://playkingdom.cl"
  }
  @start_urls = ["https://playkingdom.cl/juegos-de-mesa"]
  @config = {}

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
