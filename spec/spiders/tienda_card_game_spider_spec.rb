# frozen_string_literal: true

require "spider_helper"

RSpec.describe TiendaCardGameSpider do
  let(:fixture_directory) { "tienda_card_game" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 25 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(25)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.cardgame.cl/collections/juegos-de-mesa/products/aventureros-al-tren-londres",
          title: "¡AVENTUREROS AL TREN! LONDRES",
          price: 19_990,
          stock: true,
          image_url: "https://www.cardgame.cl/cdn/shop/products/74784258-3ad2-488d-baef-30a946773fd5_2048x.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.cardgame.cl/collections/juegos-de-mesa/products/agricola-15%C2%BA-aniversario",
          title: "AGRÍCOLA 15º ANIVERSARIO",
          price: 54_990,
          stock: true,
          image_url: "https://www.cardgame.cl/cdn/shop/files/20220629095531_9474_2048x.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.cardgame.cl/collections/juegos-de-mesa/products/la-feria-de-las-pulgas-de-titirilquen",
          title: "31 MINUTOS: LA FERIA DE LAS PULGAS DE TITIRILQUÉN",
          price: 12_990,
          stock: false,
          image_url: "https://www.cardgame.cl/cdn/shop/products/LaFeria_3D_2048x.png"
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
        expected = "https://www.cardgame.cl/collections/juegos-de-mesa?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfdGl0bGUiLCJzdiI6IkFHUklDT0xBOiBCT1NRVUVTIFkgQ0VOQUdBTEVTIiwiZCI6ImYiLCJ1aWQiOjM3MDUxOTg1MTMzODUwLCJsIjoyNSwibyI6MCwiciI6IkNEUCIsInYiOjF9.4liuPLpfawcdw-YZAFUcCnJYzSDF4pm4REtk4A0pbgY"
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
