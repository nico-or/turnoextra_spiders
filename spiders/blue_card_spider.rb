# frozen_string_literal: true

# Blue Card store spider
class BlueCardSpider < EcommerceEngines::Bsale::Spider
  @name = "blue_card_spider"
  @store = {
    name: "Blue Card",
    url: "https://www.bluecard.cl/"
  }
  @start_urls = ["https://www.bluecard.cl/collection/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )
end
