# frozen_string_literal: true

# Tertulia store spider
class TertuliaSpider < EcommerceEngines::WooCommerce::Spider
  @name = "tertulia_spider"
  @store = {
    name: "Tertulia",
    url: "https://tertulia.cl/"
  }
  @start_urls = ["https://tertulia.cl/categoria-producto/juego-de-mesa/"]

  image_url_strategy(:sized)
end
