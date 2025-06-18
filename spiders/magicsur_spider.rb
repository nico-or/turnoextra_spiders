# frozen_string_literal: true

# Magicsur store spider
class MagicsurSpider < EcommerceEngines::PrestaShop::Spider
  @name = "magicsur_spider"
  @store = {
    name: "magicsur",
    url: "https://www.magicsur.cl/"
  }
  @start_urls = ["https://www.magicsur.cl/15-juegos-de-mesa-magicsur-chile"]
  @config = {}

  private

  def get_price(node)
    price_node = node.at_css("span.product-price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css("form button.add-to-cart").nil?
  end
end
