# frozen_string_literal: true

# Una Tiendita De Juegos store spider
class UnaTienditaDeJuegosSpider < ApplicationSpider
  @name = "una_tiendita_de_juegos_spider"
  @store = {
    name: "Una Tiendita De Juegos",
    url: "https://www.unatienditadejuegos.cl/"
  }
  @start_urls = ["https://www.unatienditadejuegos.cl/todos?page=1"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      stock: "div.product-block__label--status"
    }
  )
end
