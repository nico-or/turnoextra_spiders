# frozen_string_literal: true

# Mirax store spider
class MiraxSpider < ApplicationSpider
  @name = "mirax_spider"
  @store = {
    name: "Mirax",
    url: "https://www.mirax.cl"
  }
  @start_urls = [
    "https://www.mirax.cl/buscadorx.php?categoria=1317",
    "https://www.mirax.cl/buscadorx.php?categoria=48",
    "https://www.mirax.cl/buscadorx.php?categoria=49",
    "https://www.mirax.cl/buscadorx.php?categoria=705",
    "https://www.mirax.cl/buscadorx.php?categoria=706",
    "https://www.mirax.cl/buscadorx.php?categoria=90097",
    "https://www.mirax.cl/buscadorx.php?categoria=90132",
    "https://www.mirax.cl/buscadorx.php?categoria=90133",
    "https://www.mirax.cl/buscadorx.php?categoria=90153"
  ]

  # Store uses query parameters to set the product ID,
  # for this reason we must skip the Formatter Pipeline.
  #
  # example: https://www.mirax.cl/detalles.php?codigo=ID
  @pipelines = %i[validator saver]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "section.catalog-grid div.tile",
      next_page: "ul.pagination a.fa-angle-right",
    }
  )

  selector :url, "div.descripcion-producto a"
  selector :title, "div.descripcion-producto a"
  selector :price, "div.precio a"
  selector :stock, "a.add-cart-btn.avisame"


  private

  def get_image_url(node, url)
    rel_url = node.at_css("img").attr("src")
    Helpers.absolute_url(rel_url, base_url: url)
  end
end
