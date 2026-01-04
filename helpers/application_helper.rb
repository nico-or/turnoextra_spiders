# frozen_string_literal: true

# Methods defined here are available for any spider
# Part of Tanakai proyect definition
module ApplicationHelper
  def scan_int(string)
    string.scan(/\d/).join.to_i
  end
end
