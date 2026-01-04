# frozen_string_literal: true

# El Arcanista store spider
class ElArcanistaSpider < EcommerceEngines::Shopify::Spider
  @name = "el_arcanista_spider"
  @store = {
    name: "El Arcanista",
    url: "https://elarcanista.cl/"
  }
  @start_urls = [
    "https://elarcanista.cl/collections/famliy-games",
    "https://elarcanista.cl/collections/party-games"
  ]

  selector :index_product, "product-card"
  selector :url, "a.product-name"
  selector :title, "a.product-name"
  selector :price, "span.item-price"
  selector :stock, "span.badge-sold"

  def next_page_url(response, url)
    node = response.at_css("infinite-scroll")
    return unless node

    rel_url = node["data-url"]
    absolute_url(rel_url, base: url)
  end

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["data-src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
