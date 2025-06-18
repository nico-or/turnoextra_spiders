# frozen_string_literal: true

# Demente Games store spider
class DementegamesSpider < EcommerceEngines::PrestaShop::Spider
  @name = "dementegames_spider"
  @store = {
    name: "Demente Games",
    url: "https://www.dementegames.cl/"
  }
  @start_urls = ["https://dementegames.cl/10-juegos-de-mesa?q=Existencias-En+stock"]
  @config = {}

  def next_page_url(response, url)
    # This store doesn't disable the next page link on the last pagination result
    next_page = response.at_css("nav.pagination li a[rel=next]")
    return if next_page.nil? || next_page.classes.include?("disabled")

    absolute_url(next_page[:href], base: url)
  end

  private

  def in_stock?(node)
    node.at_css("form button")["disabled"].nil?
  end
end
