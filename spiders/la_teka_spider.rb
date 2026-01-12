# frozen_string_literal: true

# La Teka store spider
class LaTekaSpider < EcommerceEngines::Shopify::Spider
  @name = "la_teka_spider"
  @store = {
    name: "La Teka",
    url: "https://lateka.cl"
  }
  @start_urls = ["https://lateka.cl/collections/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul#product-grid div.card",
      next_page: "nav.pagination a.pagination__item--prev"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "h3",
      price: "span.price-item--sale",
      stock: "product-form button[disabled]"
    }
  )
end
