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

  def parse_index(response, url:, data: {})
    super(response, url:, selector: "div#Collection ul.grid li", data:)
  end

  def next_page_url(response, url)
    super(response, url, "ul.pagination li:last-child a")
  end

  private

  def get_title(node)
    super(node, "a span")
  end

  def get_price(node)
    super(node, "dl span.price-item")
  end

  def in_stock?(node)
    super(node, "dl.price--sold-out")
  end

  # TODO: This store loads product images lazily.
  # The data-srcset attribute is not immediately available when using the Mechanize engine.
  # It doesn't work with SeleniumChrome either. We need to find a way to trigger the image load.
  def get_image_url(_node)
    nil
  end
end
