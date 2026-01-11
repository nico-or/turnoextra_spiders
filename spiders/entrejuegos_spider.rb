# frozen_string_literal: true

# Entrejuegos  store spider
class EntrejuegosSpider < ApplicationSpider
  @name = "entrejuegos_spider"
  @store = {
    name: "Entrejuegos",
    url: "https://www.entrejuegos.cl/"
  }
  @start_urls = ["https://www.entrejuegos.cl/1064-juegos-de-mesa?page=1"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Entrejuegos::ProductCardParser
  )
end
