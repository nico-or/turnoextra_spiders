# frozen_string_literal: true

require "spider_helper"

RSpec.describe JuegosGoriSpider do
  let(:fixture_directory) { "juegos_gori" }
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
          url: "https://www.juegosgori.cl/timeline-twist-pop-culture",
          title: "Timeline Twist – Pop Culture - Juego de Cartas",
          price: 14_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegos-gori/image/61224738"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.juegosgori.cl/mtg-edge-of-eternities-collectors-booster",
          title: "MTG: Edge of Eternities Collector's Booster",
          price: 29_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegos-gori/image/64795787"
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
        expected = "https://www.juegosgori.cl/juegos-de-mesa?page=2"
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
