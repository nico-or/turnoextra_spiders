# frozen_string_literal: true

# Dr. Juegos store spider
class DrJuegosSpider < EcommerceEngines::PrestaShop::Spider
  @name = "dr_juegos_spider"
  @store = {
    name: "Dr. Juegos",
    url: "https://www.drjuegos.cl"
  }
  @start_urls = ["https://www.drjuegos.cl/2-todos-los-productos?q=Disponibilidad-En+stock"]
  @config = {}

  selector :title, "h5"
  selector :stock, "div.product-availability span.unavailable"
  selector :url, "h5 a"
end
