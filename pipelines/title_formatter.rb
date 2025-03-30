# frozen_string_literal: true

class TitleFormatter < Tanakai::Pipeline
  def process_item(item, options: {})
    # remove whitespace
    item[:title].strip!

    # remove trailing language
    # (disabled because storing the original ingo as-is might be more valuable)
    #
    # languages = %w[Inglés Español].flat_map { [it, it.downcase] }
    # formats = [" - %s", " (%s)"]
    # suffixes = languages.product(formats).map { |lang, fmt| format(fmt, lang) }
    # suffixes.each { |suffix| item[:title].delete_suffix!(suffix) }

    item
  end
end
