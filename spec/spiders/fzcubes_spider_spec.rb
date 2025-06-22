# frozen_string_literal: true

require "spider_helper"

RSpec.describe FzcubesSpider do
  let(:fixture_directory) { "fzcubes" }
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
          url: "https://fzcubes.cl/producto/a-prueba-de-retos/",
          title: "¡A Prueba de Retos!",
          price: 24_990,
          stock: true,
          image_url: "https://fzcubes.cl/wp-content/uploads/2024/06/20231122113004_12952.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://fzcubes.cl/producto/almanac/",
          title: "Almanac",
          price: 54_500,
          stock: true,
          image_url: "https://fzcubes.cl/wp-content/uploads/2023/06/20211008143848_1020.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://fzcubes.cl/producto/marea-alta/",
          title: "¡Marea Alta!",
          price: 12_990,
          stock: false,
          image_url: "https://fzcubes.cl/wp-content/uploads/2022/05/marea-alta.jpg"
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
        expected = "https://fzcubes.cl/categoria-producto/juegos-de-mesa/page/2/"
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
