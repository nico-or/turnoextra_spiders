# frozen_string_literal: true

class TitleFormatter < Tanakai::Pipeline
  def process_item(item, options: {})
    item[:title] = format_title(item[:title])

    item
  end

  private

  def format_title(title)
    title.strip
  end
end
