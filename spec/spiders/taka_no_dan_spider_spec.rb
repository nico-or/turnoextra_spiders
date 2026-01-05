# frozen_string_literal: true

require "spider_helper"

RSpec.describe TakaNoDanSpider, :spider, engine: :prestashop do
  let(:fixture_directory) { "taka_no_dan" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 15 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(15)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://takanodan.cl/cartas/9795-marvel-champions-el-juego-de-cartas-magneto-pack-de-heroe.html",
          title: "Marvel Champions: El Juego de Cartas - Magneto / Pack de Héroe",
          price: 16_000,
          stock: true,
          image_url: "https://takanodan.cl/28408-large_default/marvel-champions-el-juego-de-cartas-magneto-pack-de-heroe.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://takanodan.cl/cartas/9556-doggy-style-2da-edicion.html",
          title: "Doggy Style 2da Edición",
          price: 14_000,
          stock: true,
          image_url: "https://takanodan.cl/27815-large_default/doggy-style-2da-edicion.jpg"
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
        expected = "https://takanodan.cl/212-cartas?p=2"
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
