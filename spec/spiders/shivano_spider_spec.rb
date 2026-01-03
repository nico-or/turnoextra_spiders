# frozen_string_literal: true

require "spider_helper"

RSpec.describe ShivanoSpider do
  let(:fixture_directory) { "shivano" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 30 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(30)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://shivano.cl/juegos-de-cartas/20-arkham-horror-el-juego-de-cartas-ed-revisada.html",
          title: "Arkham Horror: El juego de cartas (Ed. Revisada)",
          price: 60_000,
          stock: true,
          image_url: "https://shivano.cl/2962-tm_large_default/arkham-horror-el-juego-de-cartas-ed-revisada.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://shivano.cl/juegos-de-mesa/564-smallworld.html",
          title: "SmallWorld",
          price: 40_000,
          stock: true,
          image_url: "https://shivano.cl/2994-tm_large_default/smallworld.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://shivano.cl/juegos-de-mesa/3955-coffee-rush.html",
          title: "Coffee Rush",
          price: 40_000,
          stock: false,
          image_url: "https://shivano.cl/8329-tm_large_default/coffee-rush.jpg"
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
        expected = "https://shivano.cl/12-juegos-de-mesa?p=2"
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
