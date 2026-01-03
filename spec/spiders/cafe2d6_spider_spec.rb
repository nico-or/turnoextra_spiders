# frozen_string_literal: true

require "spider_helper"

RSpec.describe Cafe2d6Spider do
  let(:fixture_directory) { "cafe2d6" }
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
          url: "https://www.cafe2d6.cl/collections/all/products/7-wonders-duel-lotr-duelo-por-la-tierra-media",
          title: "7 Wonders Duel: Lord of the Rings – Duelo por la Tierra Media | Juego de Estrategia para 2 Jugadores, Inspirado en El Señor de los Anillos",
          price: 31_900,
          stock: true,
          image_url: "https://www.cafe2d6.cl/cdn/shop/files/el-senor-de-los-anillos-duelo-por-la-tierra-media-1_400x400_crop_center.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.cafe2d6.cl/collections/all/products/concept",
          title: "Concept",
          price: 31_900,
          stock: true,
          image_url: "https://www.cafe2d6.cl/cdn/shop/products/CAFE2D6_PRODUCTOS_CONCEPT_400x400_crop_center.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.cafe2d6.cl/collections/all/products/5-minute-dungeon",
          title: "5 Minute Dungeon",
          price: 31_900,
          stock: false,
          image_url: "https://www.cafe2d6.cl/cdn/shop/files/5-minute-dungeon-1_400x400_crop_center.jpg"
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
        expected = "https://www.cafe2d6.cl/collections/all?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfdGl0bGUiLCJzdiI6IkRpeGl0IiwiZCI6ImYiLCJ1aWQiOjE2NTEyNTY1ODcwNjcyLCJsIjoyNCwibyI6MCwiciI6IkNEUCIsInYiOjF9.RxxZHziCt2_I2A_oS_7zBo-JdN-EmWmZY97NDyElg4w"
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
