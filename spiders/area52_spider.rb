# frozen_string_literal: true

# Area 52 store spider
class Area52Spider < EcommerceEngines::Shopify::Spider
  @name = "area52_spider"
  @store = {
    name: "Area 52",
    url: "https://area52.cl/"
  }
  @start_urls = ["https://area52.cl/collections/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul#product-grid div.card",
      next_page: "nav.pagination a.pagination__item--prev"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Area52::ProductCardParser
  )
end
