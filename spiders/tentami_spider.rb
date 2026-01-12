# frozen_string_literal: true

# Tentami store spider
# Note: uses the same frontend as LaTekaSpider
class TentamiSpider < EcommerceEngines::Shopify::Spider
  @name = "tentami_spider"
  @store = {
    name: "Tentami",
    url: "https://tentami.cl"
  }
  @start_urls = ["https://tentami.cl/collections/juegos-de-mesa"]
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
