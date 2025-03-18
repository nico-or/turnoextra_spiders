# frozen_string_literal: true

module ApplicationHelper
  # Put here custom methods which are will be available for any spider
  def scan_int(string)
    string.scan(/\d/).join.to_i
  end
end
