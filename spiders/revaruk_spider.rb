# frozen_string_literal: true

# Revaruk store spider
class RevarukSpider < ApplicationSpider
  @name = "revaruk_spider"
  @store = {
    name: "Revaruk",
    url: "https://revaruk.cl"
  }
  @start_urls = ["https://revaruk.cl/product-category/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
