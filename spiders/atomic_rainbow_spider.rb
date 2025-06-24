# frozen_string_literal: true

# Atomic Rainbow store spider
class AtomicRainbowSpider < EcommerceEngines::Jumpseller::Spider
  @name = "atomic_rainbow_spider"
  @store = {
    name: "Atomic Rainbow",
    url: "https://www.atomicrainbow.cl/"
  }
  @start_urls = ["https://www.atomicrainbow.cl/juego-de-mesa"]

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
    price_node = node.at_css("div.product-block__price span:first-child")
    return unless price_node

    price_node
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.text)
  end
end
