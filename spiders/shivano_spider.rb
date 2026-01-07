# frozen_string_literal: true

# Shivano store spider
class ShivanoSpider < ApplicationSpider
  @name = "shivano_spider"
  @store = {
    name: "Shivano",
    url: "https://shivano.cl/"
  }

  @start_urls = ["https://shivano.cl/12-juegos-de-mesa?p=1"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul.product_list li.ajax_block_product",
      next_page: "ul.pagination li#pagination_next a[href]",
    }
  )

  selector :title, "h5 a.product-name span.list-name"
  selector :url, "h5 a.product-name"
  selector :price, "span.price"
  selector :stock, "span.availability span.out-of-stock"

  private

  def get_image_url(node, _url)
    node.at_css("img")[:src].sub("home_default", "large_default")
  rescue NoMethodError
    nil
  end
end
