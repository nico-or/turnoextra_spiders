# frozen_string_literal: true

# Donde Juego store spider
class DondeJuegoSpider < ApplicationSpider
  @name = "donde_juego_spider"
  @store = {
    name: "Donde Juego",
    url: "https://dondejuego.cl/"
  }
  @start_urls = ["https://dondejuego.cl/categoria-producto/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "ul.products li.product-type-simple"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
