# frozen_string_literal: true

# Ludorapia store spider
class LudorapiaSpider < ApplicationSpider
  @name = "ludorapia_spider"
  @store = {
    name: "Ludorapia",
    url: "https://ludorapia.jumpseller.com/"
  }
  @start_urls = ["https://ludorapia.jumpseller.com/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser
  )
end
