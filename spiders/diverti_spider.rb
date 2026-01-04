# frozen_string_literal: true

# Diverti store spider
class DivertiSpider < EcommerceEngines::PrestaShop::Spider
  @name = "diverti_spider"
  @store = {
    name: "Diverti",
    url: "https://www.diverti.cl/"
  }
  @start_urls = ["https://www.diverti.cl/juegos-de-mesa-16?en-stock=1"]
  @config = {}

  def next_page_url(response, url)
    # This store doesn't disable the next page link on the last pagination result
    next_page_node = response.at_css("nav.pagination li a[rel=next]")
    return if next_page_node.nil? || next_page_node.classes.include?("disabled")

    absolute_url(next_page_node[:href], base: url)
  end

  private

  def in_stock?(node)
    node.at_css("div.ago").text.strip.empty?
  end
end
