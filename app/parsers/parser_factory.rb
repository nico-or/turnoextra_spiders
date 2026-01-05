class ParserFactory
  attr_reader :klass, :selectors

  def initialize(klass:, selectors:)
    @klass = klass
    @selectors = selectors
  end

  def build(node, base_url:)
    klass.new(node, base_url:, selectors:)
  end
end
