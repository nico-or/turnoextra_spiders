# frozen_string_literal: true

# Devir store spider
# engine: ??
class DevirSpider < ApplicationSpider
  @name = "devir_spider"
  @store = {
    name: "Devir",
    url: "https://www.devir.cl/"
  }
  @start_urls = ["https://devir.cl/juegos-de-mesa?p=1"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.products li.item",
      next_page: "a[title='Siguiente']"
    }
  )

  selector :title, "strong a"
  selector :url, "strong a"

  private

  def in_stock?(node)
    # check the presence of the add to cart form
    node.at_css("form")&.attr("data-role") == "tocart-form"
  end

  def get_price(node)
    price_node = node.at_css("span[data-price-type=finalPrice]")
    return unless price_node

    clean_price_text = price_node.attr("data-price-amount")
    scan_int(clean_price_text)
  end

  def get_image_url(node, _url)
    node.at_css("img.product-image-photo")[:src]
  rescue NoMethodError
    nil
  end
end
