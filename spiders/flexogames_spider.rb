# frozen_string_literal: true

# Flexo's Games store spider
class FlexogamesSpider < EcommerceEngines::Shopify::Spider
  @name = "flexogames_spider"
  @store = {
    name: "Flexo's Games",
    url: "https://www.flexogames.cl/"
  }
  @start_urls = ["https://www.flexogames.cl/collections/juegos-de-mesa"]
  @config = {}

  selector :index_product, "div#Collection ul.grid li"
  selector :next_page, "ul.pagination li:last-child a"
  selector :title, "a span"
  selector :price, "dl span.price-item"
  selector :stock, "dl.price--sold-out"

  private

  # TODO: This store loads product images lazily.
  # The data-srcset attribute is not immediately available when using the Mechanize engine.
  # It doesn't work with SeleniumChrome either. We need to find a way to trigger the image load.
  def get_image_url(_node)
    nil
  end
end
