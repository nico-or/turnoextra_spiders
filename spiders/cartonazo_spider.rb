# frozen_string_literal: true

# Cartonazo store spider
class CartonazoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "cartonazo_spider"
  @store = {
    name: "Cartonazo",
    url: "https://cartonazo.com"
  }
  @start_urls = ["https://cartonazo.com/categoria-producto/juego-de-mesa"]
  @config = {}

  image_url_strategy(:srcset)
end
