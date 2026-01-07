# frozen_string_literal: true

module Helpers
  def self.absolute_url(rel_url, base_url:)
    uri = Addressable::URI.parse(rel_url).normalize
    URI.join(base_url, uri).to_s
  end

  def self.scan_int(string)
    string.scan(/\d/).join.to_i
  end
end
