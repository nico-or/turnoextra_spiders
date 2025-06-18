# frozen_string_literal: true

# Entrejuegos  store spider
class EntrejuegosSpider < EcommerceEngines::PrestaShop::Spider
  @name = "entrejuegos_spider"
  @store = {
    name: "Entrejuegos",
    url: "https://www.entrejuegos.cl/"
  }
  @start_urls = ["https://www.entrejuegos.cl/1064-juegos-de-mesa?page=1"]
  @config = {}

  private

  def get_title(node)
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end

  def price?(node)
    # example: https://www.entrejuegos.cl/juegos-de-mesa/16717-everdell-spirecrest.html
    # sometimes listings appear in the index but don't have a price element
    # when that happens, the 'add to cart' button is also disabled
    # this is different from products marked as 'out of stock'
    # which have a price tag element
    price_node = node.at_css("span.price")
    !price_node.nil?
  end

  def purchasable?(node)
    in_stock?(node) && price?(node)
  end
end
