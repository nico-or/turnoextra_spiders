# frozen_string_literal: true

require "spider_helper"

RSpec.describe BlueCardSpider do
  let(:fixture_directory) { "blue_card" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.bluecard.cl/product/monopoly-stranger-things",
          title: "Monopoly Stranger Things",
          price: 33_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/93109/product/M_descarga-49361.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.bluecard.cl/product/yu-gi-oh-structure-deck-blue-eyes-white-destiny-ingles",
          title: "Yu-Gi-Oh!: Structure Deck Blue-Eyes White Destiny - Inglés",
          price: 13_590,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/93109/product/M_sdwd-decken3818.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.bluecard.cl/product/dungeons-and-dragons-guia-de-volo-de-los-monstruos",
          title: "Dungeons and Dragons: Guía de Volo de los Monstruos",
          price: 52_990,
          stock: false,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/93109/product/M_volo3939.png"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.bluecard.cl/collection/juegos-de-mesa?order=price&way=ASC&limit=12&page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_false.html"))
        Nokogiri::HTML(html)
      end

      it "has no next page" do
        actual = spider.next_page_url(response, store_url)
        expected = nil
        expect(actual).to eq(expected)
      end
    end
  end
end
