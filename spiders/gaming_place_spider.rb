# frozen_string_literal: true

# Gaming Place store spider
class GamingPlaceSpider < EcommerceEngines::Jumpseller::Spider
  @name = "gaming_place_spider"
  @store = {
    name: "Gaming Place",
    url: "https://www.gamingplace.cl/"
  }
  @start_urls = ["https://www.gamingplace.cl/juegos-de-mesa"]

  selector :index_product, "div.row div.product-block"
  selector :next_page, "div.category-pager a:last-child[href]"
  selector :url, "a"
  selector :stock, "a.not-available"
  selector :image_split, "resize"

  private

  def get_title(node)
    node.at_css("img")[:alt].strip
  end

  def regular_price(node)
    node.at_css("div.list-price span.product-block-list")
  end

  def discount_price(node)
    node.at_css("div.list-price span.product-block-normal")
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.text)
  end
end
