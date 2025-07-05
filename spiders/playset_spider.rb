# frozen_string_literal: true

# Playset store spider
class PlaysetSpider < EcommerceEngines::WooCommerce::Spider
  @name = "playset_spider"
  @store = {
    name: "Playset",
    url: "https://www.playset.cl/"
  }
  @start_urls = ["https://www.playset.cl/categoria-producto/juegos-de-mesa/"]

  selector :index_product, "div.products div.product"
  selector :title, "p.product-title"
  image_url_strategy(:sized)
end
