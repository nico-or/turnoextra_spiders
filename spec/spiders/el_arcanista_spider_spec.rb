# frozen_string_literal: true

require "spider_helper"

RSpec.describe ElArcanistaSpider, :spider, engine: :shopify do
  let(:fixture_directory) { "el_arcanista" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 32 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(32)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://elarcanista.cl/collections/famliy-games/products/31-minutos-doggy-style",
          title: "31 MINUTOS - DOGGY STYLE",
          price: 18_000,
          stock: true,
          image_url: "https://elarcanista.cl/cdn/shop/files/doggystyle_35ccbecc-e155-43ad-b733-f8a1c2e548db.jpg"
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
          url: "https://elarcanista.cl/collections/famliy-games/products/asmounstablenino",
          title: "UNSTABLE UNICORNS PARA NIÑOS",
          price: 24_990,
          stock: false,
          image_url: "https://elarcanista.cl/cdn/shop/files/uupn.jpg"
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
        expected = "https://elarcanista.cl/collections/famliy-games?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfdGl0bGUiLCJzdiI6IlNBTFRBIFBBTCBMQU8gLSBTSUVNUFJFIERFIFdOIiwiZCI6ImYiLCJ1aWQiOjM3OTgyODg5NjQwMDg1LCJsIjozMiwibyI6MCwiciI6IkNEUCIsInYiOjF9.rm48xb46sUheh-mfhZfwusIaXg-SkXSGh8P3AHhsMzs"
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
