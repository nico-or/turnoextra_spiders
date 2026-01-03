# frozen_string_literal: true

# Gato Arcano store spider
class GatoArcanoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "gato_arcano_spider"
  @store = {
    name: "Gato Arcano",
    url: "https://gatoarcano.cl/"
  }
  @start_urls = ["https://gatoarcano.cl/product-category/juegos-de-mesa/"]

  selector :next_page, "link[rel=next]"

  image_url_strategy(:sized)
end
