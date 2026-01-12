# frozen_string_literal: true

# Ludopalooza store spider
class LudopaloozaSpider < EcommerceEngines::Shopify::Spider
  @name = "ludopalooza_spider"
  @store = {
    name: "Ludopalooza",
    url: "https://ludopalooza.cl/"
  }
  @start_urls = ["https://ludopalooza.cl/collections/all"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul#product-grid li.grid__item",
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
