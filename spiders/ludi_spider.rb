# frozen_string_literal: true

# Ludi store spider
class LudiSpider < EcommerceEngines::WooCommerce::Spider
  @name = "ludi_spider"
  @store = {
    name: "Ludi",
    url: "https://www.ludi.cl"
  }
  @start_urls = ["https://www.ludi.cl/tienda"]
  @config = {}

  image_url_strategy(:sized)
end
