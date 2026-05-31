# frozen_string_literal: true

# Magic 4 Ever store spider
class Magic4EverSpider < ApplicationSpider
  @name = "magic_4_ever_spider"
  @store = {
    name: "Magic 4 Ever",
    url: "https://www.m4e.cl/"
  }
  @start_urls = ["https://www.m4e.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser
  )
end
