# frozen_string_literal: true

# Ludipuerto store spider
class LudipuertoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "ludipuerto_spider"
  @store = {
    name: "Ludipuerto",
    url: "https://www.ludipuerto.cl/"
  }
  @start_urls = ["https://www.ludipuerto.cl/categoria-producto/juegos-de-mesa/"]

  selector :index_product, "div.products div.product"
  selector :title, "h3"

  image_url_strategy(:sized)
end
