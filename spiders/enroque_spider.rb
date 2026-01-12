# frozen_string_literal: true

# Enroque store spider
class EnroqueSpider < EcommerceEngines::Shopify::Spider
  @name = "enroque_spider"
  @store = {
    name: "enroque",
    url: "https://www.juegosenroque.cl/"
  }
  @start_urls = [
    "https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa"
  ]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div#filter-results li.js-pagination-result",
      next_page: "nav ul.pagination li:last-child a[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "a.card-link",
      price: "strong.price__current",
      stock: "span.product-label--sold-out",
      image_attr: "data-src"
    }
  )
end
