# frozen_string_literal: true

# Updown store spider
class UpdownSpider < EcommerceEngines::WooCommerce::Spider
  @name = "updown_spider"
  @store = {
    name: "Updown",
    url: "https://www.updown.cl/"
  }
  @start_urls = ["https://www.updown.cl/categoria-producto/juegos-de-mesa/"]
  @config = {}
end
