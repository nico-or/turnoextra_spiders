# frozen_string_literal: true

# Area 52 store spider
class Area52Spider < EcommerceEngines::Shopify::Spider
  @name = "area52_spider"
  @store = {
    name: "Area 52",
    url: "https://area52.cl/"
  }
  @start_urls = ["https://area52.cl/collections/juegos-de-mesa"]

  selector :index_product, "ul#product-grid div.card"
  selector :next_page, "nav.pagination a.pagination__item--prev"
  selector :title, "h3"
  selector :price, "span.price-item--sale"
  selector :stock, "product-form button[disabled]"

  private

  def in_stock?(node)
    node.at_css("span.badge")&.text != "Agotado"
  end
end
