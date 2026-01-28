# frozen_string_literal: true

# Vortex Juegos store spider
class VortexJuegosSpider < ApplicationSpider
  @name = "vortex_juegos_spider"
  @store = {
    name: "Vortex Juegos",
    url: "https://vortexjuegos.cl/"
  }
  @start_urls = ["https://vortexjuegos.cl/tienda/?filter_stock_status=instock"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
