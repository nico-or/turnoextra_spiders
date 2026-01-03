# frozen_string_literal: true

require "spider_helper"

RSpec.describe WargamingSpider do
  let(:fixture_directory) { "wargaming" }
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
          url: "https://www.wargaming.cl/product/5-minute-dungeon-maldicion-otra-vez-no",
          title: "5 MINUTE DUNGEON - ¡MALDICIÓN! ¡OTRA VEZ NO!",
          price: 22_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/16153/product/M_20240627112424-139647443.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.wargaming.cl/product/azul-pabellones-acristalados-expansion",
          title: "AZUL: PABELLONES ACRISTALADOS (EXPANSIÓN)",
          price: 10_493,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/16153/product/M_azul8564.jpg"
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
        expected = "https://www.wargaming.cl/collection/juegos-de-mesa?order=name&way=ASC&limit=24&page=2"
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
