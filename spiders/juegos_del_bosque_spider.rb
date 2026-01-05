# frozen_string_literal: true

# Juegos Del Bosque store spider
class JuegosDelBosqueSpider < EcommerceEngines::Jumpseller::Spider
  @name = "juegos_del_bosque_spider"
  @store = {
    name: "Juegos Del Bosque",
    url: "https://www.juegosdelbosque.cl/"
  }
  @start_urls = ["https://www.juegosdelbosque.cl/juego-de-mesa"]

  selector :stock, "div.product-block__label--status"
end
