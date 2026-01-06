# frozen_string_literal: true

# Play Kingdom store spider
class PlayKingdomSpider < EcommerceEngines::Jumpseller::Spider
  @name = "play_kingdom_spider"
  @store = {
    name: "Play Kingdom",
    url: "https://playkingdom.cl"
  }
  @start_urls = ["https://playkingdom.cl/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  selector :stock, "div.product-block__label--status"
end
