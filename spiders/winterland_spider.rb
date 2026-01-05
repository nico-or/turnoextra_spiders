# frozen_string_literal: true

# Winterland store spider
class WinterlandSpider < EcommerceEngines::Bsale::Spider
  @name = "winterland_spider"
  @store = {
    name: "Winterland",
    url: "https://www.winterland.cl/"
  }
  @start_urls = ["https://www.winterland.cl/collection/todos"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )
end
