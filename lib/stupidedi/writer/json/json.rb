module Stupidedi
  using Refinements

  module Writer
    class Json
      autoload :Element,  "stupidedi/writer/json/element"
      autoload :FunctionalGroup,  "stupidedi/writer/json/functional_group"
      autoload :Interchange,  "stupidedi/writer/json/interchange"
      autoload :Loop,  "stupidedi/writer/json/loop"
      autoload :NullNode,  "stupidedi/writer/json/null_node"
      autoload :Segment,  "stupidedi/writer/json/segment"
      autoload :Table,  "stupidedi/writer/json/table"
      autoload :TransactionSet,  "stupidedi/writer/json/transaction_set"
      autoload :Transmission,  "stupidedi/writer/json/transmission"

      def initialize(node)
        @node = node
      end

      # @return [Hash]
      def write(out = Hash.new { |k, v| self[k] = v })
        build(@node, out)
        out
      end

      private

      def resolve_traverser(node)
        case
        when node.transmission?
          Transmission
        when node.interchange?
          Interchange
        when node.segment?
          Segment
        when node.loop?
          Loop
        when node.element?
          Element
        when node.functional_group?
          FunctionalGroup
        when node.transaction_set?
          TransactionSet
        when node.table?
          Table
        else
          NullNode
        end.new(node)
      end

      def build(node, out)
        traverser = resolve_traverser(node)

        traverser.reduce(out) do |children, memo = {}|
          build(children, memo)
        end

        out
      end
    end
  end
end
