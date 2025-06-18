# frozen_string_literal: true

# Revaruk store spider
class RevarukSpider < EcommerceEngines::WooCommerce::Spider
  @name = "revaruk_spider"
  @store = {
    name: "Revaruk",
    url: "https://revaruk.cl"
  }
  @start_urls = ["https://revaruk.cl/product-category/juegos-de-mesa"]
  @config = {}
end
