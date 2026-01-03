# frozen_string_literal: true

require "spider_helper"

RSpec.describe BuhoJuegosDeMesaSpider do
  let(:fixture_directory) { "buho_juegos_de_mesa" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 20 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(20)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://buhojuegosdemesa.cl/collections/catalogo/products/harmonies",
          title: "Harmonies",
          price: 33_000,
          stock: true,
          image_url: nil
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://buhojuegosdemesa.cl/collections/catalogo/products/pack-santa-trinidad",
          title: "PACK: Santa Trinidad",
          price: 85_000,
          stock: true,
          image_url: nil
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
        expected = "https://buhojuegosdemesa.cl/collections/catalogo?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InBvc2l0aW9uIiwic3YiOjI1LCJkIjoiZiIsInVpZCI6NDIxODMwMTY0ODA4NTAsImwiOjIwLCJvIjowLCJyIjoiQ0RQIiwidiI6MX0.ItrH0h3H4WyKjW5xmWsc2odY4kw9grXKz64fo48TfMo"
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
