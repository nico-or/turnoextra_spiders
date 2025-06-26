# frozen_string_literal: true

# Una Tiendita De Juegos store spider
class UnaTienditaDeJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "una_tiendita_de_juegos_spider"
  @store = {
    name: "Una Tiendita De Juegos",
    url: "https://www.unatienditadejuegos.cl/"
  }
  @start_urls = ["https://www.unatienditadejuegos.cl/todos?page=1"]

  selector :index_product, "article.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :url, "a"
  selector :title, "a.product-block__name"
  selector  :price, "div.product-block__price"
  selector  :stock, "div.product-block__label--status"
  selector :image_split, "thumb"
end
