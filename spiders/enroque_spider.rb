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

  selector :title, "a.card-link"
  selector :price, "strong.price__current"
  selector :stock, "span.product-label--sold-out"
  selector :image_attr, "data-src"
end
