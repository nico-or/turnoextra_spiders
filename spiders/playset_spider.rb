# frozen_string_literal: true

# Playset store spider
class PlaysetSpider < ApplicationSpider
  @name = "playset_spider"
  @store = {
    name: "Playset",
    url: "https://www.playset.cl/"
  }
  @start_urls = ["https://www.playset.cl/categoria-producto/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.products div.product"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser,
    selectors: {
      title: "p.product-title"
    }
  )
end
