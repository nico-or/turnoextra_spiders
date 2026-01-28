# frozen_string_literal: true

# Mirzu store spider
class MirzuSpider < ApplicationSpider
  @name = "mirzu_spider"
  @store = {
    name: "Mirzu",
    url: "https://mirzu.cl/"
  }
  @start_urls = ["https://mirzu.cl/tienda/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
