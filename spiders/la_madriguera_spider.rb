# frozen_string_literal: true

# La Madriguera store spider
class LaMadrigueraSpider < ApplicationSpider
  @name = "la_madriguera_spider"
  @store = {
    name: "La Madriguera",
    url: "https://tiendalamadriguera.cl/"
  }
  @start_urls = ["https://tiendalamadriguera.cl/product-category/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      next_page: "div.paginator ol.wp-paginate li a.next"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
