# frozen_string_literal: true

# Mana House store spider
class ManaHouseSpider < EcommerceEngines::Shopify::Spider
  @name = "mana_house_spider"
  @store = {
    name: "Mana House",
    url: "https://manahouse.cl/"
  }
  @start_urls = ["https://manahouse.cl/collections/juegos-de-mesa"]

  selector :index_product, "div.collection__products div.product-grid-item"
  selector :next_page, "div.pagination span.next a[href]"
  selector :title, "a.product-grid-item__title"
  selector :price, "a.product-grid-item__price"
  selector :stock, "div.product__badge div.product__badge__item--sold"

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["srcset"].split[-2]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
