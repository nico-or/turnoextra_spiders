require_relative "tanakai_helper"

RSpec.shared_examples "a product node parser" do
  let(:node) do
    html = File.read(filename)
    Nokogiri::HTML(html)
  end

  let(:item) { spider.send(:parse_product_node, node, url: store_url) }

  it "parses the correct URL" do
    expect(item[:url]).to eq(expected[:url])
  end

  it "parses the correct title" do
    expect(item[:title]).to eq(expected[:title])
  end

  it "parses the correct price" do
    expect(item[:price]).to eq(expected[:price])
  end

  it "parses the correct stock value" do
    expect(item[:stock]).to eq(expected[:stock])
  end

  it "parses the correct image URL" do
    expect(item[:image_url]).to eq(expected[:image_url])
  end
end
