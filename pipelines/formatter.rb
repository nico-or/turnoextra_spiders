# frozen_string_literal: true

# Formats an item attributes
class Formatter < Tanakai::Pipeline
  def process_item(item, options: {})
    item[:title] = format_title(item[:title])
    item[:url] = format_url(item[:url])

    item
  end

  private

  def format_title(title)
    title.strip
  end

  def strip_url(url)
    uri = URI.parse(url)
    uri.query = nil
    uri.fragment = nil
    uri.to_s
  end

  def format_url(url)
    strip_url(url)
  end
end
