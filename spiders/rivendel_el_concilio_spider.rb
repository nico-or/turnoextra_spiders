# frozen_string_literal: true

# Rivendel El Concilio store spider
class RivendelElConcilioSpider < ApplicationSpider
  @name = "rivendel_el_concilio_spider"
  @store = {
    name: "Rivendel El Concilio",
    url: "https://www.rivendelelconcilio.cl/"
  }
  @start_urls = ["https://www.rivendelelconcilio.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser,
    selectors: {
      next_page: "div.category-pager a:last-child[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    Stores::LaTribuGames::ProductCardParser,
    selectors: {
      price: "div.price span.block-price"
    }
  )
end
