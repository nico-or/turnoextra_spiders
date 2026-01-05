# frozen_string_literal: true

require "spider_helper"

RSpec.describe MagicsurSpider, :spider, engine: :prestashop do
  let(:fixture_directory) { "magicsur" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 24 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(24)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.magicsur.cl/juegos-de-mesa-magicsur-chile/5131-exit-robo-en-el-misisipi.html",
          title: "Exit: Robo en el Misisipi",
          price: 12_990,
          stock: true,
          image_url: "https://www.magicsur.cl/18977-large_default/exit-robo-en-el-misisipi.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.magicsur.cl/juegos-de-mesa-magicsur-chile/7964-tiny-epic-game-of-thrones.html",
          title: "Tiny Epic Game Of Thrones",
          price: 28_792,
          stock: true,
          image_url: "https://www.magicsur.cl/29091-large_default/tiny-epic-game-of-thrones.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.magicsur.cl/juegos-de-mesa-magicsur-chile/896-dobble-infantil.html",
          title: "Dobble Infantil",
          price: 12_990,
          stock: false,
          image_url: "https://www.magicsur.cl/18533-large_default/dobble-infantil.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an unavailable index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_unavailable.html") }

      let(:expected) do
        {
          url: "https://www.magicsur.cl/juegos-de-mesa-magicsur-chile/1738-just-one.html",
          title: "Just One",
          price: 23_000,
          stock: false,
          image_url: "https://www.magicsur.cl/5043-large_default/just-one.jpg"
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
        expected = "https://www.magicsur.cl/15-juegos-de-mesa-magicsur-chile?page=2"
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
