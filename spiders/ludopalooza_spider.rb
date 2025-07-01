# frozen_string_literal: true

# Ludopalooza store spider
class LudopaloozaSpider < EcommerceEngines::Shopify::Spider
  @name = "ludopalooza_spider"
  @store = {
    name: "Ludopalooza",
    url: "https://ludopalooza.cl/"
  }
  @start_urls = ["https://ludopalooza.cl/collections/all"]

  selector :index_product, "ul#product-grid li.grid__item"
  selector :next_page, "nav.pagination a.pagination__item--prev"
  selector :title, "h3"
  selector :price, "span.price-item--sale"
  selector :stock, "product-form button[disabled]"

  def get_image_url(node, _url)
    url = node.at_css("img")["src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
