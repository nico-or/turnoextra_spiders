# frozen_string_literal: true

# Planetaloz spider
class PlanetalozSpider < EcommerceEngines::PrestaShop::Spider
  @name = "planetaloz_spider"
  @store = {
    name: "Planetaloz",
    url: "https://www.planetaloz.cl"
  }
  @start_urls = ["https://www.planetaloz.cl/14-juegos-de-mesa?q=Disponibilidad-En+stock"]
  @config = {}

  title_strategy :slug
end
