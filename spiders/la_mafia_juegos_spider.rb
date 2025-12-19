# frozen_string_literal: true

# La Mafia Juegos store spider
class LaMafiaJuegosSpider < EcommerceEngines::WooCommerce::Spider
  @name = "la_mafia_juegos_spider"
  @store = {
    name: "La Mafia Juegos",
    url: "https://lamafiajuegos.cl/"
  }
  @start_urls = ["https://lamafiajuegos.cl/shop/"]

  image_url_strategy(:sized)

  def get_price(node)
    price_node = node.css("span.price span.amount").last
    scan_int(price_node.text) if price_node
  end
end
