# frozen_string_literal: true

require_relative "tanakai_helper"

RSpec.shared_examples "a URL sanitizer" do |field|
  subject(:formatted_item) { pipeline.process_item(item) }

  context "when #{field} has query parameters" do
    let(field) { "https://example.com/path?foo=bar&baz=qux" }

    it "removes query parameters" do
      expect(formatted_item[field]).to eq("https://example.com/path")
    end
  end

  context "when #{field} has a fragment" do
    let(field) { "https://example.com/path#section" }

    it "removes fragment" do
      expect(formatted_item[field]).to eq("https://example.com/path")
    end
  end

  context "when #{field} has both query parameters and a fragment" do
    let(field) { "https://example.com/path?foo=bar#section" }

    it "removes both" do
      expect(formatted_item[field]).to eq("https://example.com/path")
    end
  end

  context "when #{field} has invalid characters" do
    let(field) { "https://example.com/¿example.png" }

    it "returns nil" do
      expect(formatted_item[field]).to be_nil
    end
  end

  context "when #{field} has a non-uri string" do
    let(field) { "example invalid string" }

    it "returns nil" do
      expect(formatted_item[field]).to be_nil
    end
  end

  context "when #{field} has a nil value" do
    let(field) { nil }

    it "returns nil" do
      expect(formatted_item[field]).to be_nil
    end
  end
end
