# frozen_string_literal: true

# Topo Token store spider
class TopoTokenSpider < ApplicationSpider
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

  @product_parser_factory = ParserFactory.new(
    Stores::TopoToken::ProductCardParser
  )
end
