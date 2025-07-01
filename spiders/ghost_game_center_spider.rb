# frozen_string_literal: true

# Ghost Game Center store spider
class GhostGameCenterSpider < EcommerceEngines::WooCommerce::Spider
  @name = "ghost_game_center_spider"
  @store = {
    name: "Ghost Game Center",
    url: "https://ghostgamecenter.cl/"
  }
  @start_urls = ["https://ghostgamecenter.cl/juegos-de-mesa-2/"]

  selector :index_product, "div.wd-products div.wd-product"
  selector :title, "h3.wd-entities-title a"

  image_url_strategy(:sized)
end
