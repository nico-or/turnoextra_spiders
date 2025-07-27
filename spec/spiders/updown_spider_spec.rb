# frozen_string_literal: true

require "spider_helper"

RSpec.describe UpdownSpider do
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read("spec/fixtures/updown/index_page_paginate_true.html")
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { "spec/fixtures/updown/product_index_node_regular.html" }

      let(:expected) do
        {
          url: "https://www.updown.cl/producto/fundas-stronghold-mini-european-44x68mm/",
          title: "Fundas Stronghold Mini European 44x68mm",
          price: 1_990,
          stock: true,
          image_url: "https://www.updown.cl/wp-content/uploads/2025/07/original-294.jpeg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { "spec/fixtures/updown/product_index_node_discounted.html" }

      let(:expected) do
        {
          url: "https://www.updown.cl/producto/star-realms-escenarios/",
          title: "Star Realms: Escenarios",
          price: 2_480,
          stock: true,
          image_url: "https://www.updown.cl/wp-content/uploads/2024/11/standard_resolution-610.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/updown/index_page_paginate_true.html")
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.updown.cl/categoria-producto/juegos-de-mesa/page/2/"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/updown/index_page_paginate_false.html")
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
