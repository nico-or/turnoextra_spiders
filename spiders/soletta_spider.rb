# frozen_string_literal: true

# Soletta store spider
class SolettaSpider < EcommerceEngines::Bsale::Spider
  @name = "soletta_spider"
  @store = {
    name: "Soletta",
    url: "https://www.soletta.cl/"
  }
  @start_urls = ["https://www.soletta.cl/collection/todos"]

  selector :index_product, "div.bs-product"
  selector :next_page, "ul.pagination li:last-child a.page-link[href]"
  selector :title, "h2"
  selector :stock, "div.bs-stock"
  selector :price, "div.bs-product-final-price"
  selector :image_attr, "data-src"

  def next_page_url(response, url)
    selector = get_selector(:next_page)
    next_page = response.at_css(selector)
    return if next_page.nil? || next_page[:href] == "#"

    absolute_url(next_page[:href], base: url)
  end
end
