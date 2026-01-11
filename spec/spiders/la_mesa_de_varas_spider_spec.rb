# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaMesaDeVarasSpider, :spider, engine: :prestashop do
  let(:fixture_directory) { "la_mesa_de_varas" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://lamesadevaras.cl/inicio/115-aventureros-al-tren-san-francisco.html",
          title: "aventureros al tren san francisco",
          price: 19_990,
          stock: true,
          image_url: "https://lamesadevaras.cl/184-large_default/aventureros-al-tren-san-francisco.jpg"
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
          url: "https://lamesadevaras.cl/juegos-de-mesa/163-hanabi.html",
          title: "Hanabi",
          price: 24_990,
          stock: false,
          image_url: "https://lamesadevaras.cl/268-large_default/hanabi.jpg"
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
        expected = "https://lamesadevaras.cl/9-juegos-de-mesa?page=2"
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
