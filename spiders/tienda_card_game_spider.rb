# frozen_string_literal: true

# Tienda Card Game store spider
class TiendaCardGameSpider < EcommerceEngines::Bsale::Spider
  @name = "tienda_card_game_spider"
  @store = {
    name: "Tienda Card Game",
    url: "https://www.cardgame.cl/"
  }
  @start_urls = ["https://www.cardgame.cl/collection/juegos-de-mesa"]
  @config = {}
end
