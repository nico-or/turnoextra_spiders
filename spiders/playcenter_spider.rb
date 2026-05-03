# frozen_string_literal: true

# Playcenter store spider
class PlaycenterSpider < ApplicationSpider
  @name = "playcenter_spider"
  @store = {
    name: "Playcenter",
    url: "https://playcenter.cl/"
  }
  @start_urls = ["https://playcenter.cl/categoria-producto/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "ul.products div.astra-shop-summary-wrap"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
