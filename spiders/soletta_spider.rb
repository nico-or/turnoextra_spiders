# frozen_string_literal: true

# Soletta store spider
class SolettaSpider < ApplicationSpider
  @name = "soletta_spider"
  @store = {
    name: "Soletta",
    url: "https://www.soletta.cl/"
  }
  @start_urls = ["https://www.soletta.cl/collection/todos"]

  @index_parser_factory = ParserFactory.new(
    Stores::Soletta::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductCardParser,
    selectors: {
      title: "h2",
      stock: "div.bs-stock",
      price: "div.bs-product-final-price",
      image_attr: "data-src"

    }
  )
end
