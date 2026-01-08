# frozen_string_literal: true

# Gaming Place store spider
class GamingPlaceSpider < ApplicationSpider
  @name = "gaming_place_spider"
  @store = {
    name: "Gaming Place",
    url: "https://www.gamingplace.cl/"
  }
  @start_urls = ["https://www.gamingplace.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser,
    selectors: {
      next_page: "div.category-pager a:last-child[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      title: "h4 a",
      stock: "a.not-available",
      price: ".product-block-normal, .product-block-list"
    }
  )
end
