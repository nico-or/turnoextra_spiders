# frozen_string_literal: true

require "spider_helper"

RSpec.describe Top8Spider do
  let(:fixture_directory) { "top8" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 24 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(24)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.top8.cl/product/7-wonders",
          title: "7 Wonders",
          price: 47_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/68889/product/M_7-wonders1211.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.top8.cl/product/d-d-set-de-regalo-de-los-reglamentos-basicos-2018",
          title: "D&D: Set de Regalo de los Reglamentos Básicos 2018",
          price: 135_992,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/68889/product/M_set-regalo-reglamentos8398.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.top8.cl/product/aventureros-al-tren-europa-15th-anniversary",
          title: "¡Aventureros al Tren! Europa 15th Anniversary",
          price: 99_990,
          stock: false,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/68889/product/M_aventureros-al-tren-europa-15th-anniversary0185.png"
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
        expected = "https://www.top8.cl/collection/juegos-de-mesa?order=name&way=ASC&limit=24&page=2"
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
