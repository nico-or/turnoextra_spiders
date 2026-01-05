# frozen_string_literal: true

require "spider_helper"

RSpec.describe EnroqueSpider, :spider, engine: :shopify do
  let(:fixture_directory) { "juegos_enroque" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 20 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(20)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa/products/el-senor-de-los-anillos-duelo-por-la-tierra-media",
          title: "El Señor de los Anillos - Duelo por la Tierra Media",
          price: 30_000,
          stock: true,
          image_url: "https://juegosenroque.cl/cdn/shop/files/LOTRDUEL_1.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.juegosenroque.cl/collections/ofertas/products/salsacia-vs-conservia",
          title: "Salsacia VS Conservia",
          price: 15_500,
          stock: true,
          image_url: "https://juegosenroque.cl/cdn/shop/files/22_75c80d6c-cb69-4e61-834c-3a7b315bf6b6.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa/products/coffee-rush-coffeer",
          title: "Coffee Rush",
          price: 35_000,
          stock: false,
          image_url: "https://juegosenroque.cl/cdn/shop/files/COFFEER_1.jpg"
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
        expected = "https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa?page=2"
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
