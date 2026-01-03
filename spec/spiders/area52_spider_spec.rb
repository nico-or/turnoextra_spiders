# frozen_string_literal: true

require "spider_helper"

RSpec.describe Area52Spider do
  let(:fixture_directory) { "area52" }
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
          url: "https://area52.cl/products/dominio-de-los-elementos",
          title: "Dominio de los Elementos",
          price: 19_990,
          stock: true,
          image_url: "https://area52.cl/cdn/shop/files/20240222092452_13270.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://area52.cl/products/pandemic-al-limite-expansion",
          title: "Pandemic: Al Limite - Expansión",
          price: 29_990,
          stock: true,
          image_url: "https://area52.cl/cdn/shop/files/15537132392963_zm7111es_1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://area52.cl/products/juicio-final",
          title: "Juicio Final",
          price: 19_990,
          stock: false,
          image_url: "https://area52.cl/cdn/shop/files/Caja-Juicio-Final.jpg"
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
        expected = "https://area52.cl/collections/juegos-de-mesa?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfbGluZV9pdGVtc19jb3VudCIsInN2IjoxLCJkIjoiZiIsInVpZCI6MzY5MDU0ODMyMzk2NjAsImwiOjI0LCJvIjowLCJyIjoiQ0RQIiwidiI6MX0.gF_opfS_ahTYb8ZwshdfqpqryQXx-GFKereAC1yd4EI"
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
