# frozen_string_literal: true

# Taka No Dan store spider
class TakaNoDanSpider < ApplicationSpider
  @name = "taka_no_dan_spider"
  @store = {
    name: "Taka No Dan",
    url: "https://takanodan.cl/"
  }
  @start_urls = [
    "https://takanodan.cl/212-cartas",
    "https://takanodan.cl/75-tablero",
    "https://takanodan.cl/213-mixto"
  ]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser,
    selectors: {
      index_product: "ul.product_list li.ajax_block_product",
      next_page: "ul.pagination li#pagination_next_bottom a[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductCardParser,
    selectors: {
      title: "h3.name a",
      url: "h3.name a",
      price: "span.product-price"
    }
  )
end
