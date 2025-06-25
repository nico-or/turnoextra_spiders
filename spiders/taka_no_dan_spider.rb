# frozen_string_literal: true

# Taka No Dan store spider
class TakaNoDanSpider < EcommerceEngines::PrestaShop::Spider
  @name = "taka_no_dan_spider"
  @store = {
    name: "Taka No Dan",
    url: "https://takanodan.cl/"
  }
  @start_urls = [
    "https://takanodan.cl/212-cartas",
    "https://takanodan.cl/75-tablero",
    "https://takanodan.cl/213-mixto"
  ]

  selector :index_product, "ul.product_list li.ajax_block_product"
  selector :next_page, "ul.pagination li#pagination_next_bottom a[href]"
  selector :title, "h3.name a"
  selector :url, "h3.name a"
  selector :price, "span.product-price"

  private

  def get_title(node)
    node.at_css("h3 a")[:title]
  end

  def get_image_url(node, _url)
    node.at_css("img")[:src].sub("home_default", "large_default")
  rescue NoMethodError
    nil
  end
end
