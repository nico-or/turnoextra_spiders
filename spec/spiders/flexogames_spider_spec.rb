# frozen_string_literal: true

require "spider_helper"

RSpec.describe FlexogamesSpider do
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read("spec/fixtures/flexogames/index_page_paginate_true.html")
      Nokogiri::HTML(html)
    end

    it "returns 40 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(40)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { "spec/fixtures/flexogames/product_index_node_regular.html" }

      let(:expected) do
        {
          url: "https://www.flexogames.cl/collections/juegos-de-mesa/products/tabriz",
          title: "Tabriz",
          price: 69_990,
          stock: true,
          image_url: nil
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { "spec/fixtures/flexogames/product_index_node_discounted.html" }

      let(:expected) do
        {
          url: "https://www.flexogames.cl/collections/juegos-de-mesa/products/star-wars-el-borde-exterior-asuntos-pendientes-ingles",
          title: "Star Wars Outer Rim: Unfinished Business (Inglés)",
          price: 45_990,
          stock: true,
          image_url: nil
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out of stock index product node" do
      let(:filename) { "spec/fixtures/flexogames/product_index_node_out_of_stock.html" }

      let(:expected) do
        {
          url: "https://www.flexogames.cl/collections/juegos-de-mesa/products/cursed",
          title: "Cursed!?",
          price: 15_990,
          stock: false,
          image_url: nil
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/flexogames/index_page_paginate_true.html")
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.flexogames.cl/collections/juegos-de-mesa?page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/flexogames/index_page_paginate_false.html")
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
