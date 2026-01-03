# frozen_string_literal: true

require "spider_helper"

RSpec.describe ManaHouseSpider do
  let(:fixture_directory) { "mana_house" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 36 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(36)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://manahouse.cl/collections/juegos-de-mesa/products/criaturas-de-las-sombras",
          title: "Criaturas de las Sombras",
          price: 31_990,
          stock: true,
          image_url: "https://manahouse.cl/cdn/shop/files/criaturas-de-las-sombras-01-juego-de-mesa-mana-house_96d4eb1c-5203-4bd0-9c6c-221b067a2717.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node",
            skip: "no listings were in discount at the time of writting" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "",
          title: "",
          price: 0,
          stock: true,
          image_url: ""
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://manahouse.cl/collections/juegos-de-mesa/products/la-feria-de-las-pulgas-de-titirilquen",
          title: "La Feria de las Pulgas de Titirilquén",
          price: 12_990,
          stock: false,
          image_url: "https://manahouse.cl/cdn/shop/files/la-feria-de-las-pulgas-de-titirilquen-31-minutos-01-juegos-de-mesa-mana-house.jpg"
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
        expected = "https://manahouse.cl/collections/juegos-de-mesa?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfbGluZV9pdGVtc19jb3VudCIsInN2IjoyLCJkIjoiZiIsInVpZCI6Mzg2NjAxNzE0MzIyMTIsImwiOjM2LCJvIjowLCJyIjoiQ0RQIiwidiI6MX0.v_ZB8w2_FbqZIDLB9xFq3xkpGjW2tun20AochIlZ158"
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
