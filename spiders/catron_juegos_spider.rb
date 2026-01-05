# frozen_string_literal: true

# Catron Juegos store spider
class CatronJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "catron_juegos_spider"
  @store = {
    name: "Catron Juegos",
    url: "https://www.catronjuegos.cl/"
  }
  @start_urls = ["https://www.catronjuegos.cl/juegos-de-interior/de-mesa"]

  selector :stock, "div.product-block__actions > a"
end
