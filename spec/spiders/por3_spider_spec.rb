# frozen_string_literal: true

require "spider_helper"

RSpec.describe Por3Spider do
  let(:fixture_directory) { "por3" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_false.html"))
      Nokogiri::HTML(html)
    end

    it "returns 5 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(5)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://por3.cl/producto/munchkin/",
          title: "Munchkin",
          price: 25_990,
          stock: true,
          image_url: "https://por3.cl/wp-content/uploads/2025/11/munchkin_base_01.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://por3.cl/producto/cthulhu-death-may-die-cmon-comics-vol-2-a-touch-of-providence-plus/",
          title: "Cthulhu Death May Die CMON Comics Vol. 2 A Touch of Providence Plus",
          price: 77_000,
          stock: true,
          image_url: "https://por3.cl/wp-content/uploads/2024/07/e9b224a4cf7c2d582411b4bf7ee2d0aa_original.avif"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node", skip: "store does not list out-of-stock items" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "",
          title: "",
          price: 0,
          stock: false,
          image_url: ""
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link", skip: "store has no pagination" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = ""
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
