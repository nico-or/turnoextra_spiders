# frozen_string_literal: true

require "spider_helper"

RSpec.describe ElDesafioStoreSpider do
  let(:fixture_directory) { "el_desafio_store" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://eldesafiostore.cl/producto/azul/",
          title: "Azul",
          price: 39_990,
          stock: true,
          image_url: "https://eldesafiostore.cl/wp-content/uploads/2025/04/azul.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://eldesafiostore.cl/producto/sky-team-preventa/",
          title: "Sky Team – PREVENTA",
          price: 26_990,
          stock: true,
          image_url: "https://eldesafiostore.cl/wp-content/uploads/2025/01/skyteam.png"
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
        expected = "https://eldesafiostore.cl/tienda/page/2/"
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
