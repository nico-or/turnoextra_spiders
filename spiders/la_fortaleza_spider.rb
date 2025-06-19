# frozen_string_literal: true

# La Fortaleza store spider
class LaFortalezaSpider < EcommerceEngines::Jumpseller::Spider
  @name = "la_fortaleza_spider"
  @store = {
    name: "La Fortaleza",
    url: "https://www.lafortalezapuq.cl"
  }
  @start_urls = ["https://www.lafortalezapuq.cl/jdm"]
  @config = {}

  selector :index_product, "div.products figure.product"
  selector :next_page, "nav.pagination-next-prev a[@class=next]"
  selector :url, "a"
  selector :title, "h5"
  selector :stock, "div.product-out-of-stock"

  private

  def discount_price(node)
    node.at_css("span.product-price-discount i")
  end

  def regular_price(node)
    node.at_css("span.product-price")
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    scan_int(price_node.text) if price_node
  end

  def get_image_url(node)
    super(node, "thumb")
  end
end
