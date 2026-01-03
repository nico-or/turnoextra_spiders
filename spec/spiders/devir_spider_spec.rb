# frozen_string_literal: true

require "spider_helper"

RSpec.describe DevirSpider do
  let(:fixture_directory) { "devir" }
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
          url: "https://devir.cl/hero-realms-la-perdicion-de-thandar",
          title: "Hero Realms - La perdición de Thandar",
          price: 17_990,
          stock: true,
          image_url: "https://devirinvestments.s3.eu-west-1.amazonaws.com/img/catalog/product/8436017226416-1200-face3d-copy.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://devir.cl/qawale",
          title: "Qawale",
          price: 27_891,
          stock: true,
          image_url: "https://devirinvestments.s3.eu-west-1.amazonaws.com/img/catalog/product/3421271373117-1200-face3d.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://devir.cl/fanhunter-assault",
          title: "FANHUNTER ASSAULT",
          price: 19_990,
          stock: false,
          image_url: "https://devirinvestments.s3.eu-west-1.amazonaws.com/img/catalog/product/8436017226058-1200-face3d.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an unavailable index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_unavailable.html") }

      let(:expected) do
        {
          url: "https://devir.cl/akropolis",
          title: "Akropolis",
          price: nil,
          stock: false,
          image_url: "https://devirinvestments.s3.eu-west-1.amazonaws.com/img/catalog/product/3421271375616-1200-face3d.jpg"
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
        expected = "https://devir.cl/juegos-de-mesa?p=2"
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
