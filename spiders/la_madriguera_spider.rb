# frozen_string_literal: true

# La Madriguera store spider
class LaMadrigueraSpider < EcommerceEngines::WooCommerce::Spider
  @name = "la_madriguera_spider"
  @store = {
    name: "La Madriguera",
    url: "https://tiendalamadriguera.cl/"
  }
  @start_urls = ["https://tiendalamadriguera.cl/product-category/juegos-de-mesa/"]

  selector :next_page, "div.paginator ol.wp-paginate li a.next"

  image_url_strategy(:sized)
end
