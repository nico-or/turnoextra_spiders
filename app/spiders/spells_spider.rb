# frozen_string_literal: true

# Spells store spider
class SpellsSpider < EcommerceEngines::WooCommerce::Spider
  @name = "spells_spider"
  @store = {
    name: "Spells",
    url: "https://spells.cl"
  }
  @start_urls = ["https://spells.cl/categoria-producto/juegos-de-mesa"]
  @config = {}

  image_url_strategy(:srcset)
end
