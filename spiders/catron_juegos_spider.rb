# frozen_string_literal: true

# Catron Juegos store spider
class CatronJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "catron_juegos_spider"
  @store = {
    name: "Catron Juegos",
    url: "https://www.catronjuegos.cl/"
  }
  @start_urls = ["https://www.catronjuegos.cl/juegos-de-interior/de-mesa"]

  selector :index_product, "div.product-block"
  selector :next_page, "div.custom-pager a.square-button:last-child[href]"
  selector :url, "a"
  selector  :price, ".prices .product-price"
  selector  :stock, "div.trsn > a.disabled"
  selector :image_split, "resize"

  private

  def get_title(node)
    node.at_css("img")["title"].strip
  end
end
