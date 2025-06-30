# frozen_string_literal: true

# Donde Juego store spider
class DondeJuegoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "donde_juego_spider"
  @store = {
    name: "Donde Juego",
    url: "https://dondejuego.cl/"
  }
  @start_urls = ["https://dondejuego.cl/categoria-producto/juegos-de-mesa/"]

  selector :index_product, "ul.products li.product-type-simple"
  image_url_strategy(:sized)
end
