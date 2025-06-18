# frozen_string_literal: true

# Topo Token store spider
class TopoTokenSpider < EcommerceEngines::WooCommerce::Spider
  @name = "topo_token_spider"
  @store = {
    name: "Topo Token",
    url: "https://topotoken.cl"
  }
  @start_urls = ["https://topotoken.cl/tienda"]
  @config = {}

  private

  def protected?(node)
    node.classes.include?("post-password-required")
  end

  def purchasable?(node)
    in_stock?(node) && !protected?(node)
  end

  def get_image_url(node)
    # matches an url like: "https://topotoken.cl/wp-content/uploads/2024/11/BOTCT-Box-3D-2-300x300.png"
    regex = /(?<url>.*)(?<size>-\d+x\d+)(?<ext>\..*)/

    full_url = node.at_css("img")["src"]
    match = full_url.match(regex)

    "#{match[:url]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
