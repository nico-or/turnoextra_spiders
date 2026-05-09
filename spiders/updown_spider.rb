# frozen_string_literal: true

# Updown store spider
class UpdownSpider < ApplicationSpider
  @name = "updown_spider"
  @store = {
    name: "Updown",
    url: "https://www.updown.cl/"
  }
  @start_urls = ["https://www.updown.cl/categoria-producto/juegos-de-mesa/?stock_status=instock"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Stores::Updown::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
