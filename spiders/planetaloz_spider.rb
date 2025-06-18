# frozen_string_literal: true

# Planetaloz spider
class PlanetalozSpider < EcommerceEngines::PrestaShop::Spider
  @name = "planetaloz_spider"
  @store = {
    name: "Planetaloz",
    url: "https://www.planetaloz.cl"
  }
  @start_urls = ["https://www.planetaloz.cl/14-juegos-de-mesa?q=Disponibilidad-En+stock"]
  @config = {}

  private

  def get_title(node)
    url = node.at_css("img")[:src]
    File.basename(url, ".jpg").gsub("-", " ")
  end
end
