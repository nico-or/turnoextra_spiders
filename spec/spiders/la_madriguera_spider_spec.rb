# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaMadrigueraSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "la_madriguera" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 18 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(18)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://tiendalamadriguera.cl/product/7-wonders-duel/",
          title: "7 Wonders Duel",
          price: 24_990,
          stock: true,
          image_url: "https://tiendalamadriguera.cl/wp-content/uploads/2021/12/1-16.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://tiendalamadriguera.cl/product/aeons-end/",
          title: "Aeon’s End",
          price: 81_000,
          stock: true,
          image_url: "https://tiendalamadriguera.cl/wp-content/uploads/2021/12/11-2.jpg"
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
        expected = "https://tiendalamadriguera.cl/product-category/juegos-de-mesa/page/2"
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
