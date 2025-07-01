# frozen_string_literal: true

# Juegos Del Bosque store spider
class JuegosDelBosqueSpider < EcommerceEngines::Jumpseller::Spider
  @name = "juegos_del_bosque_spider"
  @store = {
    name: "Juegos Del Bosque",
    url: "https://www.juegosdelbosque.cl/"
  }
  @start_urls = ["https://www.juegosdelbosque.cl/juego-de-mesa"]

  selector :index_product, "article.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :url, "a"
  selector :title, "h2.product-block__title"
  selector :price, "div.product-block__price"
  selector :stock, "div.product-block__label--status"
  selector :image_split, "resize"
end
