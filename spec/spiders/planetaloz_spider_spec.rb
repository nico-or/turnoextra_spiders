# frozen_string_literal: true

require "spider_helper"

RSpec.describe PlanetalozSpider do
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read("spec/fixtures/planetaloz/index_page_paginate_true.html")
      Nokogiri::HTML(html)
    end

    it "returns 60 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(60)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { "spec/fixtures/planetaloz/product_index_node_regular.html" }

      let(:expected) do
        {
          url: "https://www.planetaloz.cl/juegos-de-mesa/8871-que-dice-chile-familias-en-juego-segunda-edicion.html",
          title: "que dice chile familias en juego segunda edicion",
          price: 22_000,
          stock: true,
          image_url: "https://www.planetaloz.cl/20715-large_default/que-dice-chile-familias-en-juego-segunda-edicion.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { "spec/fixtures/planetaloz/product_index_node_discounted.html" }

      let(:expected) do
        {
          url: "https://www.planetaloz.cl/juegos-de-mesa/8803-happy-mochi-clutch-box.html",
          title: "happy mochi clutch box",
          price: 10_800,
          stock: true,
          image_url: "https://www.planetaloz.cl/20546-large_default/happy-mochi-clutch-box.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/planetaloz/index_page_paginate_true.html")
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.planetaloz.cl/14-juegos-de-mesa?q=Disponibilidad-En+stock&page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/planetaloz/index_page_paginate_false.html")
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
