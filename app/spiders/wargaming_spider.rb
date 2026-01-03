# frozen_string_literal: true

# Wargaming store spider
class WargamingSpider < EcommerceEngines::Bsale::Spider
  @name = "wargaming_spider"
  @store = {
    name: "Wargaming",
    url: "https://www.wargaming.cl/"
  }
  @start_urls = ["https://www.wargaming.cl/collection/juegos-de-mesa"]
end
