# frozen_string_literal: true

# Cartones Pesados store spider
class CartonesPesadosSpider < EcommerceEngines::WooCommerce::Spider
  @name = "cartones_pesados_spider"
  @store = {
    name: "Cartones Pesados",
    url: "https://cartonespesados.cl"
  }
  @start_urls = ["https://cartonespesados.cl/shop/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "ul li.product",
      next_page: "a.wp-block-query-pagination-next"
    }
  )

  selector :title, "h3 a"

  private

  image_url_strategy(:sized)

  def get_price(node)
    price_node = node.css("span.amount bdi").last
    scan_int(price_node.text) if price_node
  end
end
