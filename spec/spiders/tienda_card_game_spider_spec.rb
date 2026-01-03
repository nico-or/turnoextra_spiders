# frozen_string_literal: true

require "spider_helper"

RSpec.describe TiendaCardGameSpider do
  let(:fixture_directory) { "tienda_card_game" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 15 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(15)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.cardgame.cl/product/3-ring-circus-solitary-deck",
          title: "3 Ring Circus Solitary Deck",
          price: 1_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/114464/product/3-ring-circus-solitary-deck8965.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node", skip: "no discounted products" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

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
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.cardgame.cl/product/nemesis-lockdown",
          title: "Némesis: Lockdown",
          price: 174_990,
          stock: false,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/114464/product/71c56yfa1wl-ac-sl15000754.png"
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
        expected = "https://www.cardgame.cl/collection/juegos-de-mesa?order=price&way=ASC&limit=15&page=2"
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
