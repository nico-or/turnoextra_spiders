# frozen_string_literal: true

# Magicsur store spider
class MagicsurSpider < ApplicationSpider
  @name = "magicsur_spider"
  @store = {
    name: "magicsur",
    url: "https://www.magicsur.cl/"
  }
  @start_urls = ["https://www.magicsur.cl/15-juegos-de-mesa-magicsur-chile"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductCardParser,
    selectors: {
      price: "span.product-price",
      stock: "div.product-add-cart a.btn"
    }
  )
end
