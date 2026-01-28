# frozen_string_literal: true

# Spells store spider
class SpellsSpider < ApplicationSpider
  @name = "spells_spider"
  @store = {
    name: "Spells",
    url: "https://spells.cl"
  }
  @start_urls = ["https://spells.cl/categoria-producto/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
