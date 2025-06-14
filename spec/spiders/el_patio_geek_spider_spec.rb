# frozen_string_literal: true

require "spider_helper"

RSpec.describe ElPatioGeekSpider do
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read("spec/fixtures/el_patio_geek/index_page_paginate_true.html")
      Nokogiri::HTML(html)
    end

    it "returns 32 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(32)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { "spec/fixtures/el_patio_geek/product_index_node_regular.html" }

      let(:expected) do
        {
          url: "https://www.elpatiogeek.cl/products/amigos-de-mierda",
          title: "Amigos de Mierda",
          price: 12_990,
          stock: true,
          image_url: "https://www.elpatiogeek.cl/cdn/shop/products/amigos-de-mierda_e3f78e88-6b93-4159-bd39-acd027e1d987_2048x.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { "spec/fixtures/el_patio_geek/product_index_node_discounted.html" }

      let(:expected) do
        {
          url: "https://www.elpatiogeek.cl/products/basta-tapple",
          title: "¡Basta! Juego de Mesa",
          price: 14_990,
          stock: true,
          image_url: "https://www.elpatiogeek.cl/cdn/shop/files/Sd0318762908740c68f6effd678ff36cc3_2048x.webp"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/el_patio_geek/index_page_paginate_true.html")
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.elpatiogeek.cl/collections/all?page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/el_patio_geek/index_page_paginate_false.html")
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
