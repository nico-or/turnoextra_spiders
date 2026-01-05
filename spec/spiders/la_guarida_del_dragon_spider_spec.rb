# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaGuaridaDelDragonSpider, :spider, engine: :bsale do
  let(:fixture_directory) { "la_guarida_del_dragon" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 15 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(15)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.laguaridadeldragon.cl/product/carcassone-constructores-y-comerciantes-2da-edicion",
          title: "Carcassone Constructores y comerciantes (2da edición)",
          price: 14_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/106891/product/S_carcassonne-constructores-y-comerciantes1096.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node",
            skip: "no listings were in discount at the time of writting" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "",
          title: "",
          price: 0,
          stock: true,
          image_url: ""
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.laguaridadeldragon.cl/product/virus",
          title: "Virus",
          price: 18_990,
          stock: false,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/106891/product/S_d-nq-np-644816-mla84842418153-052025-o3580.png"
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
        expected = "https://www.laguaridadeldragon.cl/collection/juegos?order=name&way=ASC&limit=15&page=2"
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
