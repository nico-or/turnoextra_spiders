# frozen_string_literal: true

# Somos Juegos store spider
class SomosJuegosSpider < EcommerceEngines::Shopify::Spider
  @name = "somos_juegos_spider"
  @store = {
    name: "Somos Juegos",
    url: "https://www.somosjuegos.cl"
  }
  @start_urls = ["https://www.somosjuegos.cl/collections/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div#filter-results ul.grid li.js-pagination-result",
      next_page: "nav ul.pagination li:last-child a[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "p a",
      price: "span.price__current",
      stock: "span.product-label--sold-out"
    }
  )
end
