# frozen_string_literal: true

require "spider_helper"

RSpec.describe GameOfMagicSpider do
  let(:fixture_directory) { "game_of_magic" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 24 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(24)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.gameofmagictienda.cl/product/nebula-juego-de-mesa",
          title: "Nebula Juego de mesa",
          price: 34_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/55673/product/M_premiere-52461.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.gameofmagictienda.cl/product/la-comunidad-del-anillo-el-juego-de-bazas",
          title: "La Comunidad del Anillo - El Juego de Bazas",
          price: 18_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/55673/product/M_stronghold-200-black-47908.png"
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
        expected = "https://www.gameofmagictienda.cl/collection/juegos-de-mesa?order=id&way=DESC&limit=24&page=2"
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
