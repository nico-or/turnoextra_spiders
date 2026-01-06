# frozen_string_literal: true

# Caronte Juegos De Mesa store spider
class CaronteJuegosDeMesaSpider < EcommerceEngines::WooCommerce::Spider
  @name = "caronte_juegos_de_mesa_spider"
  @store = {
    name: "Caronte Juegos De Mesa",
    url: "https://carontejuegosdemesa.cl/"
  }
  @start_urls = ["https://carontejuegosdemesa.cl/categoria-producto/juego-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  image_url_strategy(:sized)
end
