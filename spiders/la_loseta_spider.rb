# frozen_string_literal: true

# La Loseta store spider
class LaLosetaSpider < EcommerceEngines::WooCommerce::Spider
  @name = "la_loseta_spider"
  @store = {
    name: "La Loseta",
    url: "https://laloseta.cl/"
  }
  @start_urls = ["https://laloseta.cl/catalogo/swoof1/product_cat-juego-de-mesa/instock/"]
  @config = {}

  private

  def get_image_url(node)
    # Example: https://laloseta.cl/wp-content/uploads/woocommerce-placeholder-300x300.png
    full_url = node.at_css("img")["src"]
    match = full_url.match(/(?<url>.*)(?<size>-\d+x\d+)(?<ext>\..*)/)
    return unless match

    "#{match[:url]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
