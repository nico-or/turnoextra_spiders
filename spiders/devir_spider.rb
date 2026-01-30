# frozen_string_literal: true

# Devir store spider
class DevirSpider < ApplicationSpider
  @name = "devir_spider"
  @store = {
    name: "Devir",
    url: "https://www.devir.cl/"
  }
  @start_urls = ["https://devir.cl/juegos-de-mesa?p=1"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.products li.item",
      next_page: "a[title='Siguiente']"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Devir::ProductCardParser
  )
end
