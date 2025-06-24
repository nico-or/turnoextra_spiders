# frozen_string_literal: true

# Kaio Juegos store spider
class KaioJuegosSpider < EcommerceEngines::PrestaShop::Spider
  @name = "entrejuegos_spider"
  @name = "kaio_juegos_spider"
  @store = {
    name: "Kaio Juegos",
    url: "https://kaiojuegos.cl/"
  }
  @start_urls = ["https://kaiojuegos.cl/18-juegos-de-mesa"]

  private

  def get_title(node)
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end
end
