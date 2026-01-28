# frozen_string_literal: true

# Rata De Mesa store spider
class RataDeMesaSpider < ApplicationSpider
  @name = "rata_de_mesa_spider"
  @store = {
    name: "Rata De Mesa",
    url: "https://www.ratademesa.cl/"
  }
  @start_urls = ["https://www.ratademesa.cl/tienda/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  # selector :title, "h2.woocommerce-loop-product__title"

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
