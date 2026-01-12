# frozen_string_literal: true

# Cafe2d6 store spider
class Cafe2d6Spider < EcommerceEngines::Shopify::Spider
  @name = "cafe2d6_spider"
  @store = {
    name: "Cafe2d6",
    url: "https://www.cafe2d6.cl/"
  }
  @start_urls = ["https://www.cafe2d6.cl/collections/all"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul#main-collection-product-grid li.item",
      next_page: "div.pager li:last-child a[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Cafe2d6::ProductCardParser
  )
end
