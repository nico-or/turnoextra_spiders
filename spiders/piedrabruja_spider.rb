# frozen_string_literal: true

# Piedrabruja store spider
# This store serves malformed HTML.
# Many tags aren't closed properly, which causes each listing node to include all subsequent nodes.
# Thus it's necessary to use only #at_css to find the first tag that matches the selector.
# This also causes that we can't easily drop the empty placeholders nodes at the end of the listings array.
class PiedrabrujaSpider < EcommerceEngines::Shopify::Spider
  @name = "piedrabruja_spider"
  @store = {
    name: "piedrabruja",
    url: "https://www.piedrabruja.cl/"
  }
  @start_urls = ["https://piedrabruja.cl/collections/juegos-de-mesa?page=1"]
  @config = {}

  selector :index_product, "ul#collection li.product-card"
  selector :title, "h3"

  def next_page_url(response, url)
    # Each page after the first hast more than one a#load-more-button element... :sigh:
    # The last page is a back to home with href='#root'.
    # I don't want to find out how the spider will behave there, so I added a guard
    next_page = response.css("a#load-more-button").last
    return if next_page.nil? || next_page[:href] == "#root"

    absolute_url(next_page[:href], base: url)
  end

  private

  def get_price(node)
    price_node = node.at_css("p.price").children.last
    return unless price_node

    scan_int(price_node.text)
  end

  def in_stock?(_node)
    true
  end

  # Since the store has empty nodes at the end of the HTML,
  # we need to rescue from errors when trying to access the :src attribute.
  def get_image_url(node, _url)
    url = node.at_css("img")["src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
