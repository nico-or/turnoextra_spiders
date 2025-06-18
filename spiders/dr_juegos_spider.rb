# frozen_string_literal: true

# Dr. Juegos store spider
class DrJuegosSpider < EcommerceEngines::PrestaShop::Spider
  @name = "dr_juegos_spider"
  @store = {
    name: "Dr. Juegos",
    url: "https://www.drjuegos.cl"
  }
  @start_urls = ["https://www.drjuegos.cl/2-todos-los-productos?q=Disponibilidad-En+stock"]
  @config = {}

  private

  def get_url(node)
    node.at_css("h5 a")[:href]
  end

  def get_title(node)
    node.at_css("h5").text.strip
  end

  def in_stock?(node)
    !node.at_css("button.add-to-cart").nil?
  end

  def get_image_url(node)
    node.at_css("img")[:src].sub("home_default", "large_default")
  rescue NoMethodError
    nil
  end
end
