# frozen_string_literal: true

# Shivano store spider
class ShivanoSpider < ApplicationSpider
  @name = "shivano_spider"
  @store = {
    name: "Shivano",
    url: "https://shivano.cl/"
  }

  @start_urls = ["https://shivano.cl/12-juegos-de-mesa?p=1"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul.product_list li.ajax_block_product",
      next_page: "ul.pagination li#pagination_next a[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Shivano::ProductCardParser
  )
end
