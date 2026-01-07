# frozen_string_literal: true

# Gamehouse Coyhaique store spider
class GamehouseCoyhaiqueSpider < ApplicationSpider
  @name = "gamehouse_coyhaique_spider"
  @store = {
    name: "Gamehouse Coyhaique",
    url: "https://www.gamehousecoyhaique.cl/"
  }
  @start_urls = ["https://www.gamehousecoyhaique.cl/collection/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductCardParser,
    selectors: {
      title: "h3[@class='bs-collection__product-title']/text()"
    }
  )
end
