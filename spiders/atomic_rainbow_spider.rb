# frozen_string_literal: true

# Atomic Rainbow store spider
class AtomicRainbowSpider < ApplicationSpider
  @name = "atomic_rainbow_spider"
  @store = {
    name: "Atomic Rainbow",
    url: "https://www.atomicrainbow.cl/"
  }
  @start_urls = ["https://www.atomicrainbow.cl/juego-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser
  )
end
