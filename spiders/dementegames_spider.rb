# frozen_string_literal: true

# Demente Games store spider
class DementegamesSpider < EcommerceEngines::PrestaShop::Spider
  @name = "dementegames_spider"
  @store = {
    name: "Demente Games",
    url: "https://www.dementegames.cl/"
  }
  @start_urls = ["https://dementegames.cl/10-juegos-de-mesa?q=Existencias-En+stock"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Stores::DementeGames::ProductIndexPageParser
  )

  selector :stock, "form button[disabled]"
end
