# frozen_string_literal: true

# Tentami store spider
# Note: uses the same frontend as LaTekaSpider
class TentamiSpider < EcommerceEngines::Shopify::Spider
  @name = "tentami_spider"
  @store = {
    name: "Tentami",
    url: "https://tentami.cl"
  }
  @start_urls = ["https://tentami.cl/collections/juegos-de-mesa"]
  @config = {}

  selector :index_product, "ul#product-grid div.card"
  selector :next_page, "nav.pagination a.pagination__item--prev"
  selector :title, "h3"
  selector :price, "span.price-item--sale"
  selector :stock, "product-form button[disabled]"
end
