# frozen_string_literal: true

# Updown store spider
class UpdownSpider < ApplicationSpider
  @name = "updown_spider"
  @store = {
    name: "Updown",
    url: "https://www.updown.cl/"
  }
  @start_urls = ["https://www.updown.cl/categoria-producto/juegos-de-mesa/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.wd-products div.wd-product",
      next_page: "ul.page-numbers a.next"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
