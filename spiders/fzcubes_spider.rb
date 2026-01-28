# frozen_string_literal: true

# Fzcubes store spider
class FzcubesSpider < ApplicationSpider
  @name = "fzcubes_spider"
  @store = {
    name: "Fzcubes",
    url: "https://fzcubes.cl/"
  }
  @start_urls = ["https://fzcubes.cl/categoria-producto/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
