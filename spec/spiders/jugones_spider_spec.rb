# frozen_string_literal: true

require "spider_helper"

RSpec.describe JugonesSpider do
  let(:fixture_directory) { "jugones" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_false.html"))
      Nokogiri::HTML(html)
    end

    it "returns 184 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(184)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.jugones.cl/productos/97-Las_Ruinas_Perdidas_de_Arnak",
          title: "Las Ruinas Perdidas de Arnak",
          price: 57_990,
          stock: true,
          image_url: "https://www.jugones.cl/img/productos/17282839191718036435arnak.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.jugones.cl/productos/81-Small_World_of_Warcraft",
          title: "Small World of Warcraft",
          price: 59_990,
          stock: true,
          image_url: "https://www.jugones.cl/img/productos/172828401616969534121681488307wow1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.jugones.cl/productos/25-",
          title: "El Señor de los Anillos, LCG (Ed. Revisada)",
          price: 54_990,
          stock: false,
          image_url: "https://www.jugones.cl/img/productos/1728284055anillos.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
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
