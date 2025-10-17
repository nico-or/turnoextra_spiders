# frozen_string_literal: true

# Catron Juegos store spider
class CatronJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "catron_juegos_spider"
  @store = {
    name: "Catron Juegos",
    url: "https://www.catronjuegos.cl/"
  }
  @start_urls = ["https://www.catronjuegos.cl/juegos-de-interior/de-mesa"]

  selector :index_product, "article.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :title, "h2 a"
  selector :url, "h2 a"
  selector :price, "div.product-block__price"
  selector :stock, "div.product-block__actions > a"
  selector :image_split, "resize"
end
