# frozen_string_literal: true

# VuduGaming store spider
class VudugamingSpider < EcommerceEngines::Jumpseller::Spider
  @name = "vudugaming_spider"
  @store = {
    name: "VuduGaming",
    url: "https://www.vudugaming.cl/"
  }
  @start_urls = ["https://www.vudugaming.cl/juegos-de-mesa"]
  @config = {}

  selector :index_product, "article.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :url, "a"
  selector :title, "h2"
  selector  :price, "div.product-block__price"
  selector  :stock, "div.product-block__actions a[title]"

  private

  def get_image_url(node)
    super(node, "resize")
  end
end
