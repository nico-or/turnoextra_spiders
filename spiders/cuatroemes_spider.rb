# frozen_string_literal: true

# Cuatroemes store spider
class CuatroemesSpider < EcommerceEngines::Jumpseller::Spider
  @name = "cuatroemes_spider"
  @store = {
    name: "Cuatroemes",
    url: "https://www.cuatroemes.cl/"
  }
  @start_urls = ["https://www.cuatroemes.cl/tienda"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  private

  def in_stock?(_node)
    true
  end
end
