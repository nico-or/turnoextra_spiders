# frozen_string_literal: true

# Juegos Gori store spider
class JuegosGoriSpider < EcommerceEngines::Jumpseller::Spider
  @name = "juegos_gori_spider"
  @store = {
    name: "Juegos Gori",
    url: "https://www.juegosgori.cl/"
  }
  @start_urls = ["https://www.juegosgori.cl/juegos-de-mesa"]

  selector :index_product, "div.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :url, "a"
  selector :title, "a.product-block__name"
  selector :stock, "div.product-block__disabled"
  selector :image_split, "resize"

  private

  def regular_price(node)
    node.at_css("div.product-block__price")
  end

  def discount_price(node)
    price_node = node.at_css("div.product-block__price > span.product-block__price--discount")
    return unless price_node

    price_node.children.first
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.text)
  end
end
