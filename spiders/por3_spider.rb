# frozen_string_literal: true

# Por3 store spider
class Por3Spider < ApplicationSpider
  @name = "por3_spider"
  @store = {
    name: "Por3",
    url: "https://por3.cl"
  }
  @start_urls = ["https://por3.cl/categoria-producto/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.products div.product"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser,
    selectors: {
      title: "p.product-title"
    }
  )
end
