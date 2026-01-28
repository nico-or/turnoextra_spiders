# frozen_string_literal: true

# Ghost Game Center store spider
class GhostGameCenterSpider < ApplicationSpider
  @name = "ghost_game_center_spider"
  @store = {
    name: "Ghost Game Center",
    url: "https://ghostgamecenter.cl/"
  }
  @start_urls = ["https://ghostgamecenter.cl/juegos-de-mesa-2/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.wd-products div.wd-product"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
