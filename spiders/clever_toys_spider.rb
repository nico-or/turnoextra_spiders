# frozen_string_literal: true

# Clever Toys store spider
# Engine: WooCommerce + Woodmart Theme
class CleverToysSpider < EcommerceEngines::WooCommerce::Spider
  @name = "clever_toys_spider"
  @store = {
    name: "Clever Toys",
    url: "https://www.clevertoys.cl/"
  }
  @start_urls = [
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/aventuras/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/cartas/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/cooperativo/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/estrategia/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/familiar/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/infantil/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/party-game/",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/wargame/"
  ]

  selector :index_product, "div.products div.product"
  selector :next_page, "div.products-footer a.woodmart-load-more[href]"
  selector :title, "h3.product-title a"
  selector :url, "h3.product-title a"
  selector :price, "span.price span.amount"

  image_url_strategy(:sized)

  private

  def get_price(node)
    selector = get_selector(:price)
    price_node = node.css(selector).last
    return unless price_node

    scan_int(price_node.text)
  end
end
