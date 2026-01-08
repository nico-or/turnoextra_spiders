# frozen_string_literal: true

# Catron Juegos store spider
class CatronJuegosSpider < ApplicationSpider
  @name = "catron_juegos_spider"
  @store = {
    name: "Catron Juegos",
    url: "https://www.catronjuegos.cl/"
  }
  @start_urls = ["https://www.catronjuegos.cl/juegos-de-interior/de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      stock: "div.product-block__actions > a"
    }
  )
end
