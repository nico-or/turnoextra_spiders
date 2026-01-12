# frozen_string_literal: true

# Buho Juegos De Mesa store spider
class BuhoJuegosDeMesaSpider < EcommerceEngines::Shopify::Spider
  @name = "buho_juegos_de_mesa_spider"
  @store = {
    name: "Buho Juegos De Mesa",
    url: "https://buhojuegosdemesa.cl/"
  }
  @start_urls = ["https://buhojuegosdemesa.cl/collections/catalogo"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.grid.grid--uniform div.grid__item",
      next_page: "div.pagination span.next a"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::BuhoJuegosDeMesa::ProductCardParser
  )
end
