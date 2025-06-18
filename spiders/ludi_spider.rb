# frozen_string_literal: true

# Ludi store spider
class LudiSpider < EcommerceEngines::WooCommerce::Spider
  @name = "ludi_spider"
  @store = {
    name: "Ludi",
    url: "https://www.ludi.cl"
  }
  @start_urls = ["https://www.ludi.cl/tienda"]
  @config = {}

  private

  def get_image_url(node)
    # Example: https://www.ludi.cl/wp-content/uploads/2025/04/00-8-300x300.jpg
    full_url = node.at_css("img")["src"]
    match = full_url.match(/(?<url>.*)(?<size>-\d+x\d+)(?<ext>\..*)/)
    return unless match

    "#{match[:url]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
