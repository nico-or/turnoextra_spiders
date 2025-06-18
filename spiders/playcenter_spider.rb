# frozen_string_literal: true

# Playcenter store spider
class PlaycenterSpider < EcommerceEngines::WooCommerce::Spider
  @name = "playcenter_spider"
  @store = {
    name: "Playcenter",
    url: "https://playcenter.cl/"
  }
  @start_urls = ["https://playcenter.cl/categoria-producto/juegos-de-mesa"]
  @config = {}

  def get_image_url(node)
    # Example: https://playcenter.cl/wp-content/uploads/2025/05/D_NQ_NP_2X_755218-MLC80923289084_122024-F-300x300.webp
    full_url = node.at_css("img")["src"]
    match = full_url.match(/(?<url>.*)(?<size>-\d+x\d+)(?<ext>\..*)/)
    return unless match

    "#{match[:url]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
