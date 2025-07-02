# frozen_string_literal: true

# Rata De Mesa store spider
class RataDeMesaSpider < EcommerceEngines::WooCommerce::Spider
  @name = "rata_de_mesa_spider"
  @store = {
    name: "Rata De Mesa",
    url: "https://www.ratademesa.cl/"
  }
  @start_urls = ["https://www.ratademesa.cl/tienda/"]

  selector :title, "h2.woocommerce-loop-product__title"

  image_url_strategy(:sized)
end
