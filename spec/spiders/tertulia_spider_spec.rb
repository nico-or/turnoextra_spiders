# frozen_string_literal: true

require "spider_helper"

RSpec.describe TertuliaSpider do
  let(:fixture_directory) { "tertulia" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 21 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(21)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://tertulia.cl/producto/hashtag/",
          title: "#_Hashtag",
          price: 7_990,
          stock: true,
          image_url: "https://tertulia.cl/wp-content/uploads/2020/04/HASTAG2150-1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://tertulia.cl/producto/toma-6-30-aniversario/",
          title: "¡Toma 6! : 30 Aniversario",
          price: 16_000,
          stock: true,
          image_url: "https://tertulia.cl/wp-content/uploads/2024/07/TOM6302450-1.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://tertulia.cl/producto/no_gracias/",
          title: "¡No Gracias!",
          price: 12_990,
          stock: false,
          image_url: "https://tertulia.cl/wp-content/uploads/2021/06/NO_GRA1450-1.jpg"
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
        expected = "https://tertulia.cl/categoria-producto/juego-de-mesa/?product-page=2"
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
