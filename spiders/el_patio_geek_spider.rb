# frozen_string_literal: true

# El Patio Geek store spider
class ElPatioGeekSpider < EcommerceEngines::Shopify::Spider
  @name = "el_patio_geek_spider"
  @store = {
    name: "El Patio Geek",
    url: "https://www.elpatiogeek.cl/"
  }
  @start_urls = ["https://www.elpatiogeek.cl/collections/all"]
  @config = {}

  selector :index_product, "div.grid-uniform div.grid-item"
  selector :next_page, "ul.pagination-custom li:last-child a"
  selector :title, "p"
  selector :price, "div.product-item--price small"
  selector :image_attr, "srcset"

  private

  def purchasable?(_node)
    true
  end
end
