# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaFortalezaSpider do
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  describe "#parse_index" do
    let(:response) do
      html = File.read("spec/fixtures/la_fortaleza/index_page_paginate_true.html")
      Nokogiri::HTML(html)
    end

    it "returns 30 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(30)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { "spec/fixtures/la_fortaleza/product_index_node_regular.html" }

      let(:expected) do
        {
          url: "https://www.lafortalezapuq.cl/ubongo-junior",
          title: "Ubongo Junior",
          price: 32_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/la-fortaleza-punta-arenas1/image/12387604"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { "spec/fixtures/la_fortaleza/product_index_node_discounted.html" }

      let(:expected) do
        {
          url: "https://www.lafortalezapuq.cl/suburbia",
          title: "Suburbia",
          price: 50_392,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/la-fortaleza-punta-arenas1/image/26357660"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out of stock index product node" do
      let(:filename) { "spec/fixtures/la_fortaleza/product_index_node_out_of_stock.html" }

      let(:expected) do
        {
          url: "https://www.lafortalezapuq.cl/earth",
          title: "Earth",
          price: 56_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/la-fortaleza-punta-arenas1/image/62623856"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    let(:url) { described_class.instance_variable_get("@store")[:url] }

    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/la_fortaleza/index_page_paginate_true.html")
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, url)
        expected = "https://www.lafortalezapuq.cl/juegos?page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/la_fortaleza/index_page_paginate_false.html")
        Nokogiri::HTML(html)
      end

      it "has no next page" do
        actual = spider.next_page_url(response, url)
        expected = nil
        expect(actual).to eq(expected)
      end
    end
  end
end
