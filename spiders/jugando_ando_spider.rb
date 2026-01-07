# frozen_string_literal: true

# Jugando Ando store spider
class JugandoAndoSpider < ApplicationSpider
  @name = "jugando_ando_spider"
  @store = {
    name: "Jugando Ando",
    url: "https://jugandoando.cl/"
  }
  @start_urls = ["https://jugandoando.cl/categoria/todos-los-juegos-28092"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.container div.row div.position-relative",
      next_page: "ul.pagination li a[@rel=next]",
    }
  )

  selector :url, "a"
  selector :title, "h3"
  selector :price, "span.text-nowrap"

  private

  def purchasable?(_node)
    true
  end

  def get_image_url(node, url)
    img_node = node.at_css("div.bg-img")
    return unless img_node

    absolute_url(img_node["data-bg"], base: url)
  end
end
