# frozen_string_literal: true

require "spider_helper"

RSpec.describe ElKingoSpider do
  let(:fixture_directory) { "el_kingo" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://elkingo.com/producto/31-minutos-arte-moderno-juego-de-mesa/",
          title: "31 Minutos Arte Moderno – Juego de mesa",
          price: 32_990,
          stock: true,
          image_url: "https://elkingo.com/wp-content/uploads/2024/10/arte-moderno-31m.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://elkingo.com/producto/coatl/",
          title: "Coatl",
          price: 32_990,
          stock: true,
          image_url: "https://elkingo.com/wp-content/uploads/2023/07/20200813104703_6028.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://elkingo.com/producto/juegos-de-mesa-aventureros-al-tren-europa-2/",
          title: "¿Quien fue?",
          price: 10_990,
          stock: false,
          image_url: "https://elkingo.com/wp-content/uploads/2023/04/quien-fue.png"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://elkingo.com/productos/?wpf=filtro&wpf_cols=3&wpf_categorias=juego-de-mesa&wpf_page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_false.html"))
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
