# frozen_string_literal: true

# Cafe2d6 store spider
class Cafe2d6Spider < EcommerceEngines::Shopify::Spider
  @name = "cafe2d6_spider"
  @store = {
    name: "Cafe2d6",
    url: "https://www.cafe2d6.cl/"
  }
  @start_urls = ["https://www.cafe2d6.cl/collections/all"]

  selector :index_product, "ul#main-collection-product-grid li.item"
  selector :next_page, "div.pager li:last-child a[href]"
  selector :url, "a"
  selector :title, "h3"
  selector :stock, "a.add-to-agotado"

  private

  def discount_price_node(node)
    price_node = node.at_css("p.price.sale")
    return unless price_node

    price_node.children.first
  end

  def regular_price_node(node)
    node.at_css("p.price")
  end

  def get_price(node)
    price_node = discount_price_node(node) || regular_price_node(node)
    scan_int(price_node.text)
  end
end
