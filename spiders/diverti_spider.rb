# frozen_string_literal: true

# Diverti store spider
class DivertiSpider < ApplicationSpider
  @name = "diverti_spider"
  @store = {
    name: "Diverti",
    url: "https://www.diverti.cl/"
  }
  @start_urls = ["https://www.diverti.cl/juegos-de-mesa-16?en-stock=1"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Stores::Diverti::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    Stores::Diverti::ProductCardParser
  )
end
