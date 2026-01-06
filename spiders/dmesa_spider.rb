# frozen_string_literal: true

# Dmesa store spider
class DmesaSpider < EcommerceEngines::WooCommerce::Spider
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

  selector :title, "div.elementor-heading-title"
  selector :url, "div.elementor-heading-title a"

  image_url_strategy(:sized)

  private

  def get_price(node)
    price_node = node.css("div[data-widget_type='woocommerce-product-price.default'] span.woocommerce-Price-amount").last # rubocop:disable Layout/LineLength
    return unless price_node

    scan_int(price_node.text)
  end

  def in_stock?(node)
    node.classes.include? "product-type-simple"
  end
end
