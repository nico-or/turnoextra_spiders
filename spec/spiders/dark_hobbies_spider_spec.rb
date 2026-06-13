# frozen_string_literal: true

require "spider_helper"

RSpec.describe DarkHobbiesSpider do
  let(:fixture_directory) { "dark_hobbies" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
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
          url: "https://www.darkhobbies.cl/products/academia-ninja?variant=47670866706686",
          title: "academia ninja",
          price: 15_990,
          stock: true,
          image_url: "https://www.darkhobbies.cl/cdn/shop/files/Academia_Ninja.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.darkhobbies.cl/products/nebula?variant=47651390783742",
          title: "nebula",
          price: 25_990,
          stock: true,
          image_url: "https://www.darkhobbies.cl/cdn/shop/files/1_9fa720c6-a6af-474f-a94c-44b0557a477c.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.darkhobbies.cl/products/arte-moderno-31-minutos?variant=47451734933758",
          title: "arte moderno 31 minutos",
          price: 24_990,
          stock: false,
          image_url: "https://www.darkhobbies.cl/cdn/shop/files/9_6f2c01e3-1ffa-4b0a-b756-bad09198b4fb.png"
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
        expected = "https://www.darkhobbies.cl/collections/all?page=2"
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
