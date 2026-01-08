# frozen_string_literal: true

# Cuatroemes store spider
class CuatroemesSpider < ApplicationSpider
  @name = "cuatroemes_spider"
  @store = {
    name: "Cuatroemes",
    url: "https://www.cuatroemes.cl/"
  }
  @start_urls = ["https://www.cuatroemes.cl/tienda"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser
  )
end
