# frozen_string_literal: true

# Vortex Juegos store spider
class VortexJuegosSpider < EcommerceEngines::WooCommerce::Spider
  @name = "vortex_juegos_spider"
  @store = {
    name: "Vortex Juegos",
    url: "https://vortexjuegos.cl/"
  }
  @start_urls = ["https://vortexjuegos.cl/tienda/?filter_stock_status=instock"]

  image_url_strategy(:sized)
end
