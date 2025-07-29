# frozen_string_literal: true

# Por Eso Estoy Pobre store spider
class PorEsoEstoyPobreSpider < EcommerceEngines::Shopify::Spider
  @name = "por_eso_estoy_pobre_spider"
  @store = {
    name: "Por Eso Estoy Pobre",
    url: "https://poresoestoypobre.cl/"
  }
  @start_urls = ["https://poresoestoypobre.cl/collections/juegos-de-mesa"]

  selector :next_page, "link[rel=next]"
  selector :index_product, "ul#product-grid > li"
  selector :title, "h3 a"
  selector :price, "div.price__regular span.price-item--regular"
  selector :stock, "div.price--sold-out"

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
