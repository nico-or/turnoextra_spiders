# frozen_string_literal: true

# La Fortaleza store spider
class LaFortalezaSpider < ApplicationSpider
  @name = "la_fortaleza_spider"
  @store = {
    name: "La Fortaleza",
    url: "https://www.lafortalezapuq.cl"
  }
  @start_urls = ["https://www.lafortalezapuq.cl/jdm"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser,
    selectors: {
      index_product: "div.products figure.product",
      next_page: "nav.pagination-next-prev a[@class=next]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      title: "h5",
      stock: "div.product-out-of-stock",
      price: "span.product-price-discount i, span.product-price"
    }
  )
end
