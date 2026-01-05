# frozen_string_literal: true

require "spider_helper"

RSpec.describe VudugamingSpider, :spider, engine: :jumpseller do
  let(:fixture_directory) { "vudugaming" }
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
          url: "https://www.vudugaming.cl/darwins-journey-espanol",
          title: "Preventa - Darwin's Journey - Español",
          price: 62_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/vudu-gaming/image/64353932"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.vudugaming.cl/star-wars-legion-moff-gideon-espanol",
          title: "Star Wars Legion: Moff Gideon - Español",
          price: 11_994,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/vudu-gaming/image/59998889"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.vudugaming.cl/star-wars-bounty-hunters",
          title: "Star Wars: Bounty Hunters - Español",
          price: 19_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/vudu-gaming/image/60940178"
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
        expected = "https://www.vudugaming.cl/juegos-de-mesa?page=2"
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
