# frozen_string_literal: true

require "spider_helper"

RSpec.describe PlaycenterSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "playcenter" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 4 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(4)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://playcenter.cl/cart/juegos-de-mesa/skull-king/",
          title: "Skull King (2da Edición)",
          price: 19_990,
          stock: true,
          image_url: "https://playcenter.cl/wp-content/uploads/2025/05/8436607940418-1200-face3d-600x600-1.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://playcenter.cl/cart/juegos-de-mesa/care-caca/",
          title: "Care Caca",
          price: 14_990,
          stock: true,
          image_url: "https://playcenter.cl/wp-content/uploads/2025/05/D_NQ_NP_2X_755218-MLC80923289084_122024-F.webp"
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
        expected = "https://playcenter.cl/categoria-producto/juegos-de-mesa/page/2/"
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

  context "with a malformed html product index page" do
    describe "#parse_index" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "product_index_page_malformed.html"))
        Nokogiri::HTML(html)
      end

      it "returns 8 items" do
        items = spider.send(:parse_index, response, url: store_url)
        expect(items.length).to eq(8)
      end

      it "returns the correct prices" do
        items = spider.send(:parse_index, response, url: store_url)
        actual_prices = items.map { it[:price] }
        expected_prices = [39_990, 14_990, 49_990, 24_990, 39_990, 25_990, 25_000, 5_990]

        expect(actual_prices).to eq(expected_prices)
      end
    end
  end
end
