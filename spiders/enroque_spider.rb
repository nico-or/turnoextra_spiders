# frozen_string_literal: true

# Enroque store spider
class EnroqueSpider < EcommerceEngines::Shopify::Spider
  @name = "enroque_spider"
  @store = {
    name: "enroque",
    url: "https://www.juegosenroque.cl/"
  }
  @start_urls = [
    "https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa",
    "https://www.juegosenroque.cl/collections/preventas",
    "https://www.juegosenroque.cl/collections/ofertas"
  ]
  @config = {}

  selector :index_product, "div#filter-results li.js-pagination-result"
  selector :next_page, "nav ul.pagination li:last-child a"
  selector :title, "a.card-link"
  selector :price, "strong.price__current"
  selector :stock, "span.product-label--sold-out"

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["data-src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
