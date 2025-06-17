# frozen_string_literal: true

require "spider_helper"

RSpec.describe PiedrabrujaSpider do
  let(:fixture_directory) { "piedrabruja" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 53 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(53)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.piedrabruja.cl/products/dinosaur-building-blocks",
          title: "Dinosaur Building Blocks",
          price: 14_990,
          stock: true,
          image_url: "https://piedrabruja.cl/cdn/shop/files/Dinosaur_Building_Blocks_Portada.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.piedrabruja.cl/products/bundle-nemesis-expansiones",
          title: "Bundle Nemesis: Expansiones",
          price: 66_980,
          stock: true,
          image_url: "https://piedrabruja.cl/cdn/shop/files/tazasD_D.png"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.piedrabruja.cl/collections/juegos-de-mesa?page=3&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfY3JlYXRlZF9hdCIsInN2IjoiMjAyNS0wNC0xMVQyMDo1NzoxMi4wMDBaIiwiZCI6ImYiLCJ1aWQiOjQwNTkyMDg2MzM1NzY4LCJsIjo0OCwibyI6MCwiciI6IkNEUCIsInYiOjF9.MGnC-RJk7T_vpFFoj1udwQq5sd4mmi2aMM0gAM6VDqg"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_false.html"))
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
