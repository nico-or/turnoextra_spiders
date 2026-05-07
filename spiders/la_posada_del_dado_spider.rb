# frozen_string_literal: true

# La Posada Del Dado store spider
class LaPosadaDelDadoSpider < EcommerceEngines::Shopify::Spider
  @name = "la_posada_del_dado_spider"
  @store = {
    name: "La Posada Del Dado",
    url: "https://laposadadeldado.cl/"
  }
  @start_urls = ["https://laposadadeldado.cl/collections/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul.product-grid li.product-grid__item",
      next_page: "link[rel=next]"
    }
  )
  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "h3",
      price: "product-price span.price",
      stock: "button.add-to-cart-button[disabled]"
    }
  )
end
