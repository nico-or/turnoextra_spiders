# frozen_string_literal: true

# Playcenter store spider
class PlaycenterSpider < EcommerceEngines::WooCommerce::Spider
  @name = "playcenter_spider"
  @store = {
    name: "Playcenter",
    url: "https://playcenter.cl/"
  }
  @start_urls = ["https://playcenter.cl/categoria-producto/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  image_url_strategy(:sized)
end
