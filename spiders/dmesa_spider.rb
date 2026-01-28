# frozen_string_literal: true

# Dmesa store spider
class DmesaSpider < ApplicationSpider
  @name = "dmesa_spider"
  @store = {
    name: "Dmesa",
    url: "https://www.dmesa.cl/product-category/juegos-de-mesa/"
  }
  @start_urls = ["https://www.dmesa.cl/product-category/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "article.product",
      next_page: "link[rel=next]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser,
    selectors: {
      url: "div.elementor-heading-title a",
      title: "div.elementor-heading-title",
      price: "div[data-widget_type='woocommerce-product-price.default'] span.woocommerce-Price-amount"
    }
  )
end
