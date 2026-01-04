# frozen_string_literal: true

# Cuatroemes store spider
class CuatroemesSpider < EcommerceEngines::Jumpseller::Spider
  @name = "cuatroemes_spider"
  @store = {
    name: "Cuatroemes",
    url: "https://www.cuatroemes.cl/"
  }
  @start_urls = ["https://www.cuatroemes.cl/tienda"]

  selector :index_product, "article.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :url, "a"
  selector :title, "h2.product-block__title"
  selector :price, "div.product-block__price"
  selector :image_split, "thumb"

  private

  def in_stock?(_node)
    true
  end
end
