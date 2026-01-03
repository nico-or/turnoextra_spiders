# frozen_string_literal: true

# La Teka store spider
class LaTekaSpider < EcommerceEngines::Shopify::Spider
  @name = "la_teka_spider"
  @store = {
    name: "La Teka",
    url: "https://lateka.cl"
  }
  @start_urls = ["https://lateka.cl/collections/juegos-de-mesa"]
  @config = {}

  selector :index_product, "ul#product-grid div.card"
  selector :next_page, "nav.pagination a.pagination__item--prev"
  selector :title, "h3"
  selector :price, "span.price-item--sale"
  selector :stock, "product-form button[disabled]"

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
