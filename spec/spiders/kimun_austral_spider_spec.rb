# frozen_string_literal: true

require "spider_helper"

RSpec.describe KimunAustralSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "kimun_austral" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 9 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(9)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://kimunaustral.cl/producto/quien-fue/",
          title: "¿Quién fue?",
          price: 11_000,
          stock: true,
          image_url: "https://kimunaustral.cl/wp-content/uploads/2024/10/Convert-to-JPG-project-1.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://kimunaustral.cl/producto/simplicity/",
          title: "Simplicity",
          price: 21_000,
          stock: true,
          image_url: "https://kimunaustral.cl/wp-content/uploads/2025/04/Resize-image-project-1.jpeg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://kimunaustral.cl/producto/carcassonne/",
          title: "Carcassonne",
          price: 21_000,
          stock: false,
          image_url: "https://kimunaustral.cl/wp-content/uploads/2024/09/1-5.png"
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
        expected = "https://kimunaustral.cl/shop/page/2/"
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
