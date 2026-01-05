# frozen_string_literal: true

# Cuatroemes store spider
class CuatroemesSpider < EcommerceEngines::Jumpseller::Spider
  @name = "cuatroemes_spider"
  @store = {
    name: "Cuatroemes",
    url: "https://www.cuatroemes.cl/"
  }
  @start_urls = ["https://www.cuatroemes.cl/tienda"]

  private

  def in_stock?(_node)
    true
  end
end
