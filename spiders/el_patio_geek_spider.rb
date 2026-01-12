# frozen_string_literal: true

# El Patio Geek store spider
class ElPatioGeekSpider < EcommerceEngines::Shopify::Spider
  @name = "el_patio_geek_spider"
  @store = {
    name: "El Patio Geek",
    url: "https://www.elpatiogeek.cl/"
  }
  @start_urls = ["https://www.elpatiogeek.cl/collections/all"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.grid-uniform div.grid-item",
      next_page: "ul.pagination-custom li:last-child a"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "p",
      price: "div.product-item--price small",
      image_attr: "srcset"
    }
  )
end
