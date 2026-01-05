# frozen_string_literal: true

require "spider_helper"

RSpec.describe KaioJuegosSpider, :spider, engine: :prestashop do
  let(:fixture_directory) { "kaio_juegos" }
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
          url: "https://kaiojuegos.cl/juegos-de-mesa/1597-1000-km-juego-de-mesa.html",
          title: "1000 km juego de mesa",
          price: 23_990,
          stock: true,
          image_url: "https://kaiojuegos.cl/1852-large_default/1000-km-juego-de-mesa.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://kaiojuegos.cl/juegos-de-mesa/1135-agricola-animales-en-la-granja.html",
          title: "agricola animales en la granja",
          price: 29_990,
          stock: true,
          image_url: "https://kaiojuegos.cl/1331-large_default/agricola-animales-en-la-granja.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://kaiojuegos.cl/juegos-de-mesa/1031-dixit-disney-juego-de-mesa.html",
          title: "dixit disney juego de mesa",
          price: 26_990,
          stock: false,
          image_url: "https://kaiojuegos.cl/1220-large_default/dixit-disney-juego-de-mesa.jpg"
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
        expected = "https://kaiojuegos.cl/18-juegos-de-mesa?page=2"
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
