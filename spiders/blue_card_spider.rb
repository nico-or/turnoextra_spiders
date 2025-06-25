# frozen_string_literal: true

# Blue Card store spider
class BlueCardSpider < EcommerceEngines::Bsale::Spider
  @name = "blue_card_spider"
  @store = {
    name: "Blue Card",
    url: "https://www.bluecard.cl/"
  }
  @start_urls = ["https://www.bluecard.cl/collection/juegos-de-mesa"]

  selector :index_product, "div.bs-collection section.grid__item"
  selector :next_page, "ul.pagination li:last-child a"
  selector :title,  "h3.bs-collection__product-title"
  selector :stock,  "div.bs-collection__stock"
  selector :price,  "div.bs-collection__product-final-price"
  selector :url, "a"
  selector :image_tag, "img"
  selector :image_attr, "src"
end
