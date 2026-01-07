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

  selector :next_page, "ul.page-numbers a.next"
  selector :index_product, "div.wd-products div.wd-product"
  selector :title, "h3"

  image_url_strategy(:srcset)
end
