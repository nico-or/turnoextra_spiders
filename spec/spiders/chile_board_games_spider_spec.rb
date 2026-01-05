# frozen_string_literal: true

require "spider_helper"

RSpec.describe ChileBoardGamesSpider, :spider, engine: :shopify do
  let(:fixture_directory) { "chile_board_games" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 40 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(40)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://chileboardgames.com/collections/todos-los-juegos/products/dobble-blister",
          title: "Dobble Blister",
          price: 12_000,
          stock: true,
          image_url: "https://chileboardgames.com/cdn/shop/products/20200821172131_6107_2048x.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://chileboardgames.com/collections/todos-los-juegos/products/t-i-m-e-stories-prophecy-of-dragons-ingles",
          title: "T.I.M.E. Stories: Prophecy Of Dragons (inglés)",
          price: 21_990,
          stock: true,
          image_url: "https://chileboardgames.com/cdn/shop/products/15537146110585_timestories.prophecydragons_2048x.jpg"
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
        expected = "https://chileboardgames.com/collections/todos-los-juegos?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfY3JlYXRlZF9hdCIsInN2IjoiMjAyMy0wOS0xNFQyMjo1Mjo0MS4wMDArMDA6MDAiLCJkIjoiZiIsInVpZCI6MzQxMTc1NDI0MTI0NjMsImwiOjQwLCJvIjowLCJyIjoiQ0RQIiwidiI6MX0.4_RTLe5wqQF5nZqMGeVKRGLajpR_jLP9eao2QwGtRAI"
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
