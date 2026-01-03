# frozen_string_literal: true

require "spider_helper"

RSpec.describe CleverToysSpider do
  let(:fixture_directory) { "clever_toys" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.clevertoys.cl/producto/danger-danger/",
          title: "DANGER, DANGER",
          price: 14_990,
          stock: true,
          image_url: "https://www.clevertoys.cl/wp-content/uploads/2025/02/CTJDM0956.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a presale index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_presale.html") }

      let(:expected) do
        {
          url: "https://www.clevertoys.cl/producto/exploding-pigeon/",
          title: "EXPLODING PIGEON",
          price: 24_990,
          stock: true,
          image_url: "https://www.clevertoys.cl/wp-content/uploads/2025/04/CTJDM0960.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.clevertoys.cl/producto/villa-panda/",
          title: "VILLA PANDA",
          price: 15_990,
          stock: true,
          image_url: "https://www.clevertoys.cl/wp-content/uploads/2024/08/CTJDM0901.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.clevertoys.cl/producto/arkham-horror-lovecraft-letter/",
          title: "ARKHAM HORROR LOVECRAFT LETTER",
          price: 15_000,
          stock: false,
          image_url: "https://www.clevertoys.cl/wp-content/uploads/2025/01/CTJDM0949.jpg"
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
        expected = "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/cartas/page/2/"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_false.html"))
        Nokogiri::HTML(html)
      end

      it "has no next page" do
        # NOTE: the store always generates the next_page link, and then dinamically removes it from the html...
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/cartas/page/7/"
        expect(actual).to eq(expected)
      end
    end
  end
end
