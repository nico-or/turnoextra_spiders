# frozen_string_literal: true

# Chucao Juegos store spider
class ChucaoJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "chucao_juegos_spider"
  @store = {
    name: "Chucao Juegos",
    url: "https://www.chucaojuegos.cl/"
  }
  @start_urls = ["https://www.chucaojuegos.cl/catalogo-completo"]

  selector :index_product, "div.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :url, "a"
  selector :title, "a.product-block__name"
  selector :stock, "div.product-block__disabled"
  selector :image_split, "thumb"

  private

  def get_price(node)
    price_node = node.at_css("div.product-block__price span:first-child")
    return unless price_node

    scan_int(price_node.text)
  end
end
