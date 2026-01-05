# frozen_string_literal: true

# La Posada Del Dado store spider
class LaPosadaDelDadoSpider < EcommerceEngines::Shopify::Spider
  @name = "la_posada_del_dado_spider"
  @store = {
    name: "La Posada Del Dado",
    url: "https://laposadadeldado.cl/"
  }
  @start_urls = ["https://laposadadeldado.cl/collections/juegos-de-mesa"]

  selector :next_page, "link[rel=next]"
  selector :index_product, "ul#product-grid > li"
  selector :title, "h3 a"
  selector :price, "div.price__regular span.price-item--regular"
  selector :stock, "div.price--sold-out"
end
