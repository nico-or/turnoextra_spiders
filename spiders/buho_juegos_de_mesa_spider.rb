# frozen_string_literal: true

# Buho Juegos De Mesa store spider
class BuhoJuegosDeMesaSpider < EcommerceEngines::Shopify::Spider
  @name = "buho_juegos_de_mesa_spider"
  @store = {
    name: "Buho Juegos De Mesa",
    url: "https://buhojuegosdemesa.cl/"
  }
  @start_urls = ["https://buhojuegosdemesa.cl/collections/catalogo"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.grid.grid--uniform div.grid__item",
      next_page: "div.pagination span.next a"
    }
  )

  selector :title, "div.product-card__name"

  private

  def get_price(node)
    price_node = node.at_css("div.product-card__price")
    return unless price_node

    scan_int(price_node.children.last.text)
  end

  def in_stock?(_node)
    true
  end
end
