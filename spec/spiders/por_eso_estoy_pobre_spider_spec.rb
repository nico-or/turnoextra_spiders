# frozen_string_literal: true

require "spider_helper"

RSpec.describe PorEsoEstoyPobreSpider, :spider, engine: :shopify do
  let(:fixture_directory) { "por_eso_estoy_pobre" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 16 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(16)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://poresoestoypobre.cl/products/la-morada-maldita-y-los-tesoros-de-pirita",
          title: "La morada maldita y los tesoros de pirita",
          price: 11_990,
          stock: true,
          image_url: "https://poresoestoypobre.cl/cdn/shop/files/moradamal1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://poresoestoypobre.cl/products/exploding-kittens-el-juego-de-tablero",
          title: "Exploding Kittens El juego de tablero",
          price: 26_990,
          stock: true,
          image_url: "https://poresoestoypobre.cl/cdn/shop/files/explo1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://poresoestoypobre.cl/products/blockbuster",
          title: "Blockbuster",
          price: 24_990,
          stock: false,
          image_url: "https://poresoestoypobre.cl/cdn/shop/files/block1_2fe3d622-5c6a-44e9-9d66-ac2d7a2296b0.jpg"
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
        expected = "https://poresoestoypobre.cl/collections/juegos-de-mesa?page=2"
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
