# frozen_string_literal: true

# Jugando Ando store spider
class JugandoAndoSpider < ApplicationSpider
  @name = "jugando_ando_spider"
  @store = {
    name: "Jugando Ando",
    url: "https://jugandoando.cl/"
  }
  @start_urls = ["https://jugandoando.cl/categoria/todos-los-juegos-28092"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.container div.row div.position-relative",
      next_page: "ul.pagination li a[@rel=next]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::JugandoAndo::ProductCardParser
  )
end
