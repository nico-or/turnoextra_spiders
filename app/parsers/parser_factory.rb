# frozen_string_literal: true

# Parser Factory
# Allows definition of Parser without a node.
# Required since node is only defined at runtime.
class ParserFactory
  attr_reader :klass, :selectors

  def initialize(klass, selectors: {})
    @klass = klass
    @selectors = selectors
  end

  def build(node, base_url:)
    klass.new(node, base_url:, selectors:)
  end
end
