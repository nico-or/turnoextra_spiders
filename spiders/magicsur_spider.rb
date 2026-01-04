# frozen_string_literal: true

# Magicsur store spider
class MagicsurSpider < EcommerceEngines::PrestaShop::Spider
  @name = "magicsur_spider"
  @store = {
    name: "magicsur",
    url: "https://www.magicsur.cl/"
  }
  @start_urls = ["https://www.magicsur.cl/15-juegos-de-mesa-magicsur-chile"]
  @config = {}

  selector :price, "span.product-price"
  selector :stock, "div.product-add-cart a.btn"
end
