# frozen_string_literal: true

require "spider_helper"

RSpec.describe JuegoManiaSpider do
  let(:fixture_directory) { "juego_mania" }
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
          url: "https://www.juegomania.cl/mala-leche-juego-de-mesa-copiar",
          title: "Mala Leche con Platano - Juego de mesa",
          price: 20_000,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegomania/image/57152073"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.juegomania.cl/union-arena-starter-deck-bleach-thousand-year-blood-war-ue01st",
          title: "Union Arena Starter Deck: Bleach Thousand-Year Blood War [UE01ST]",
          price: 19_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegomania/image/56985549"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.juegomania.cl/con-eso-no-se-jode-2-juego-de-mesa",
          title: "Con eso no se jode 2 | Juego de mesa",
          price: 11_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/juegomania/image/57827318"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an ranged index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_ranged.html") }

      let(:expected) do
        {
          url: "https://www.juegomania.cl/n's-pp-up-jtg-153/159",
          title: "N's PP Up JTG 153/159",
          price: 500,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegomania/image/63324337"
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
        expected = "https://www.juegomania.cl/juegos-de-mesa?page=2"
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
