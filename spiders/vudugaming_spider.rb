# frozen_string_literal: true

# VuduGaming store spider
class VudugamingSpider < ApplicationSpider
  @name = "vudugaming_spider"
  @store = {
    name: "VuduGaming",
    url: "https://www.vudugaming.cl/"
  }
  @start_urls = ["https://www.vudugaming.cl/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      title: "h2",
      stock: "div.product-block__actions a[title]"
    }
  )
end
