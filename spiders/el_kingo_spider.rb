# frozen_string_literal: true

# El Kingo store spider
class ElKingoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "el_kingo_spider"
  @store = {
    name: "El Kingo",
    url: "https://elkingo.com/"
  }
  @start_urls = ["https://elkingo.com/productos/?wpf=filtro&wpf_cols=3&wpf_en-stock=1&wpf_categorias=juego-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  image_url_strategy(:sized)
end
