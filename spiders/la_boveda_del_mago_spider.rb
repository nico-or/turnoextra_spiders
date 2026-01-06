# frozen_string_literal: true

# La Boveda del Mago store spider
class LaBovedaDelMagoSpider < EcommerceEngines::WooCommerce::Spider
  @name = "la_boveda_del_mago_spider"
  @store = {
    name: "La Boveda del Mago",
    url: "https://www.labovedadelmago.cl"
  }
  @start_urls = ["https://www.labovedadelmago.cl/page/1/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  image_url_strategy(:sized)
end
