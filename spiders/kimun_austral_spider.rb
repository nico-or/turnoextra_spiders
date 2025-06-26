# frozen_string_literal: true

# Kimun Austral store spider
class KimunAustralSpider < EcommerceEngines::WooCommerce::Spider
  @name = "kimun_austral_spider"
  @store = {
    name: "Kimun Austral",
    url: "https://kimunaustral.cl/"
  }
  @start_urls = ["https://kimunaustral.cl/shop/"]

  image_url_strategy(:sized)
end
