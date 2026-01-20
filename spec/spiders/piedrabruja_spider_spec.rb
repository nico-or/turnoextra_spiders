# frozen_string_literal: true

require "spider_helper"

RSpec.describe PiedrabrujaSpider, :spider, engine: :shopify do
  let(:fixture_directory) { "piedrabruja" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 2 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(2)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.piedrabruja.cl/products/zombicide-segunda-edicion-rio-z-janeiro",
          title: "Zombicide Segunda Edición - Rio Z Janeiro",
          price: 59_990,
          stock: true,
          image_url: "https://piedrabruja.cl/cdn/shop/files/BM8tz1I61Ed8lh2aDwPoQsLAdPijncRmMsIRHarF.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.piedrabruja.cl/products/master-of-orion",
          title: "Master of Orion",
          price: 19_990,
          stock: true,
          image_url: "https://piedrabruja.cl/cdn/shop/files/master-of-orion.jpg"
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
        expected = "https://www.piedrabruja.cl/collections/juegos-de-mesa?page=2"
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
