# frozen_string_literal: true

# Cartonazo store spider
class CartonazoSpider < ApplicationSpider
  @name = "cartonazo_spider"
  @store = {
    name: "Cartonazo",
    url: "https://cartonazo.com"
  }
  @start_urls = ["https://cartonazo.com/categoria-producto/juego-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
