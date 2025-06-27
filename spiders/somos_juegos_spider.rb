# frozen_string_literal: true

# Somos Juegos store spider
class SomosJuegosSpider < EcommerceEngines::Shopify::Spider
  @name = "somos_juegos_spider"
  @store = {
    name: "Somos Juegos",
    url: "https://www.somosjuegos.cl"
  }
  @start_urls = ["https://www.somosjuegos.cl/collections/juegos-de-mesa"]
  @config = {}

  selector :index_product, "div#filter-results ul.grid li.js-pagination-result"
  selector :next_page, "nav ul.pagination li:last-child a[href]"
  selector :title, "p a"
  selector :price, "span.price__current"
  selector :stock, "span.product-label--sold-out"

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
