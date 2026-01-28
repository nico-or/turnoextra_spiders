# frozen_string_literal: true

# Araucania Gaming store spider
class AraucaniaGamingSpider < ApplicationSpider
  @name = "araucania_gaming_spider"
  @store = {
    name: "Araucania Gaming",
    url: "https://araucaniagaming.cl/"
  }
  @start_urls = ["https://araucaniagaming.cl/productos/juegosdemesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser,
    selectors: {
      url: "h3 a",
      img_sized_attr: "data-src"
    }
  )
end
