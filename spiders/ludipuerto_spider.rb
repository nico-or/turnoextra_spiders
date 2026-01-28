# frozen_string_literal: true

# Ludipuerto store spider
class LudipuertoSpider < ApplicationSpider
  @name = "ludipuerto_spider"
  @store = {
    name: "Ludipuerto",
    url: "https://www.ludipuerto.cl/"
  }
  @start_urls = ["https://www.ludipuerto.cl/categoria-producto/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.products div.product"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
