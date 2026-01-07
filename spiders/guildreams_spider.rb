# frozen_string_literal: true

# Guildreams store spider
class GuildreamsSpider < ApplicationSpider
  @name = "guildreams_spider"
  @store = {
    name: "Guildreams",
    url: "https://www.guildreams.com"
  }
  @start_urls = ["https://www.guildreams.com/collection/juegos-de-mesa?order=id&way=DESC&limit=24&page=1"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser,
    selectors: {
      index_product: "div.bs-product",
      next_page: "ul.pagination li:last-child a.page-link[data-nf]"
    }
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
