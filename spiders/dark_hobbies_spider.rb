# frozen_string_literal: true

# Dark Hobbies store spider
class DarkHobbiesSpider < ApplicationSpider
  @name = "dark_hobbies_spider"
  @store = {
    name: "Dark Hobbies",
    url: "https://www.darkhobbies.cl/"
  }
  @start_urls = [
    "https://www.darkhobbies.cl/collections/juegos-de-tableros",
    "https://www.darkhobbies.cl/collections/party-game",
    "https://www.darkhobbies.cl/collections/roll-and-write",
    "https://www.darkhobbies.cl/collections/solo-duo",
    "https://www.darkhobbies.cl/collections/carrete-18",
    "https://www.darkhobbies.cl/collections/expansion"
  ]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul.product-grid li",
      next_page: "link[rel=next]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "h3",
      price: "div[ref=priceContainer] span.price",
      stock: "button[type=submit][disabled]"
    }
  )
end
