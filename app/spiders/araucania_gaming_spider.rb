# frozen_string_literal: true

# Araucania Gaming store spider
class AraucaniaGamingSpider < EcommerceEngines::WooCommerce::Spider
  @name = "araucania_gaming_spider"
  @store = {
    name: "Araucania Gaming",
    url: "https://araucaniagaming.cl/"
  }
  @start_urls = ["https://araucaniagaming.cl/productos/juegosdemesa/"]

  selector :title, "h3"
  selector :url, "h3 a"

  private

  def get_image_url(node, _url)
    # NOTE: this stores mutates the HTML after loading
    # what you see in the browser is not what mechanize gets
    node.at_css("img")["data-srcset"].split(",").last.split.first
  end
end
