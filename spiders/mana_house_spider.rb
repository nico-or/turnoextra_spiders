# frozen_string_literal: true

# Mana House store spider
class ManaHouseSpider < EcommerceEngines::Shopify::Spider
  @name = "mana_house_spider"
  @store = {
    name: "Mana House",
    url: "https://manahouse.cl/"
  }
  @start_urls = ["https://manahouse.cl/collections/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.collection__products div.product-grid-item",
      next_page: "div.pagination span.next a[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "a.product-grid-item__title",
      price: "a.product-grid-item__price",
      stock: "div.product__badge div.product__badge__item--sold",
      image_attr: "srcset"
    }
  )
end
