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

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  private

  def protected?(node)
    node.classes.include?("post-password-required")
  end

  def purchasable?(node)
    in_stock?(node) && !protected?(node)
  end

  image_url_strategy(:sized)
end
