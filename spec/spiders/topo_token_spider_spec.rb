# frozen_string_literal: true

require "spider_helper"

RSpec.describe TopoTokenSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "topo_token" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 9 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(9)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://topotoken.cl/producto/blood-on-the-clocktower-espanol/",
          title: "BLOOD ON THE CLOCKTOWER (ESPAÑOL)",
          price: 179_990,
          stock: true,
          image_url: "https://topotoken.cl/wp-content/uploads/2024/11/BOTCT-Box-3D-2.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://topotoken.cl/producto/federacion-espanol/",
          title: "FEDERACIÓN – ESPAÑOL",
          price: 49_990,
          stock: true,
          image_url: "https://topotoken.cl/wp-content/uploads/2023/12/federacion.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an unavailable index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_unavailable.html") }

      let(:expected) do
        {
          url: "https://topotoken.cl/producto/dennis-privado/",
          title: "Protegido: dennis privado",
          price: 114_980,
          stock: false,
          image_url: "https://topotoken.cl/wp-content/uploads/woocommerce-placeholder.png"
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
        expected = "https://topotoken.cl/tienda/page/2/"
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
