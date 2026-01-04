# frozen_string_literal: true

# Fzcubes store spider
class FzcubesSpider < EcommerceEngines::WooCommerce::Spider
  @name = "fzcubes_spider"
  @store = {
    name: "Fzcubes",
    url: "https://fzcubes.cl/"
  }
  @start_urls = ["https://fzcubes.cl/categoria-producto/juegos-de-mesa/"]

  image_url_strategy(:sized)
end
