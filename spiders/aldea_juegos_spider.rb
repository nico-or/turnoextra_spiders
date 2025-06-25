# frozen_string_literal: true

# Aldea Juegos store spider
class AldeaJuegosSpider < EcommerceEngines::PrestaShop::Spider
  @name = "aldea_juegos_spider"
  @store = {
    name: "Aldea Juegos",
    url: "https://www.aldeajuegos.cl"
  }
  @start_urls = ["https://www.aldeajuegos.cl/7-juegos-de-mesa?q=Disponibilidad-En+stock"]
  @config = {}

  title_strategy :slug
end
