# frozen_string_literal: true

# Wargaming store spider
class WargamingSpider < ApplicationSpider
  @name = "wargaming_spider"
  @store = {
    name: "Wargaming",
    url: "https://www.wargaming.cl/"
  }
  @start_urls = ["https://www.wargaming.cl/collection/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductCardParser
  )
end
