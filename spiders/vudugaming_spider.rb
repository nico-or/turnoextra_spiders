# frozen_string_literal: true

# VuduGaming store spider
class VudugamingSpider < EcommerceEngines::Jumpseller::Spider
  @name = "vudugaming_spider"
  @store = {
    name: "VuduGaming",
    url: "https://www.vudugaming.cl/"
  }
  @start_urls = ["https://www.vudugaming.cl/juegos-de-mesa"]
  @config = {}

  selector :title, "h2"
  selector :stock, "div.product-block__actions a[title]"
end
