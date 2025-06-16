require_relative "tanakai_helper"

RSpec.shared_examples "a store spider" do
  describe "#parse" do
    let(:parameters) do
      [
        %i[req response],
        %i[keyreq url],
        %i[key data]
      ]
    end

    it { expect(spider).to respond_to(:parse) }

    it "has the correct signature" do
      actual = spider.method(:parse).parameters
      expect(actual).to match_array(parameters)
    end
  end

  describe "#parse_index" do
    let(:parameters) do
      [
        %i[req response],
        %i[keyreq url],
        %i[key data]
      ]
    end

    it { expect(spider).to respond_to(:parse_index) }

    it "has the correct signature" do
      actual = spider.method(:parse_index).parameters
      expect(actual).to match_array(parameters)
    end
  end

  describe "#parse_product_node" do
    let(:parameters) do
      [
        %i[req node],
        %i[keyreq url]
      ]
    end

    it { expect(spider).to respond_to(:parse_product_node) }

    it "has the correct signature" do
      actual = spider.method(:parse_product_node).parameters
      expect(actual).to match_array(parameters)
    end
  end

  describe "#next_page_url" do
    let(:parameters) do
      [
        %i[req response],
        %i[req url]
      ]
    end

    it { expect(spider).to respond_to(:next_page_url) }

    it "has the correct signature" do
      actual = spider.method(:next_page_url).parameters
      expect(actual).to match_array(parameters)
    end
  end
end

RSpec.shared_examples "a product node parser" do
  let(:node) do
    html = File.read(filename)
    # Nokogiri nests the HTML snippet in document > html > body >...
    Nokogiri::HTML(html).at_css("body").first_element_child
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
