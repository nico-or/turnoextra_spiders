# frozen_string_literal: true

# Tertulia store spider
class TertuliaSpider < ApplicationSpider
  @name = "tertulia_spider"
  @store = {
    name: "Tertulia",
    url: "https://tertulia.cl/"
  }
  @start_urls = ["https://tertulia.cl/categoria-producto/juego-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
