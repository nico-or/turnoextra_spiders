# frozen_string_literal: true

require "spider_helper"

RSpec.describe TentamiSpider do
  let(:fixture_directory) { "tentami" }
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
          url: "https://tentami.cl/products/lenguas-afuera",
          title: "Lenguas Afuera!",
          price: 27_990,
          stock: true,
          image_url: "https://tentami.cl/cdn/shop/files/LENGUAS-AFUERA-CAJA.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://tentami.cl/products/transgalactica",
          title: "[PREVENTA] Transgaláctica",
          price: 50_990,
          stock: true,
          image_url: "https://tentami.cl/cdn/shop/files/8436607946632-1200-face3d_1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://tentami.cl/products/criaturas-de-las-sombras-expansion-tormenta-de-hielo",
          title: "Criaturas de las Sombras - Expansión Tormenta de Hielo",
          price: 21_990,
          stock: false,
          image_url: "https://tentami.cl/cdn/shop/files/20240618092342_13822.png"
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
        expected = "https://tentami.cl/collections/juegos-de-mesa?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfY3JlYXRlZF9hdCIsInN2IjoiMjAyNS0wNS0yNVQyMjozMjozNS4wMDArMDA6MDAiLCJkIjoiZiIsInVpZCI6NDEwOTk2NDAwNzg2MjQsImwiOjM2LCJvIjowLCJyIjoiQ0RQIiwidiI6MX0.9HaBrQwF_oR4C3frV-Dbfhxfv_Gl1XPzReGKJOkQQRU"
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
