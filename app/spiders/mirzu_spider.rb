# frozen_string_literal: true

# Mirzu store spider
class MirzuSpider < EcommerceEngines::WooCommerce::Spider
  @name = "mirzu_spider"
  @store = {
    name: "Mirzu",
    url: "https://mirzu.cl/"
  }
  @start_urls = ["https://mirzu.cl/tienda/"]

  image_url_strategy(:sized)
end
