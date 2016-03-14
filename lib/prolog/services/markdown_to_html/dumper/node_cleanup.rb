
require_relative 'node_cleanup/string_node'

module Prolog
  module Services
    class MarkdownToHtml
      class Dumper
        # Cleans up strings below a given node per our position-aware spacing
        # conventions.
        class NodeCleanup
          # Methods neither affecting nor affected by instance state
          module Internals
            def self.cleanup_detail_node(top_node, index, node_count)
              top_node.nodes[index] = _updated_string top_node, index,
                                                      node_count
            end

            def self._updated_string(top_node, index, node_count)
              position = _position_of index, node_count
              nodes = top_node.nodes
              StringNode.new(string: nodes[index], position: position).to_s
            end

            # Reek doesn't like `index` being a :reek:ControlParameter. Tough.
            def self._position_of(index, node_count)
              return :only if node_count == 1
              case index
              when node_count - 1 then :terminal
              when 0 then :initial
              else :intermediate
              end
            end
          end
          private_constant :Internals

          # We can assume that external calls of `#cleanup` pass in an array of
          # `Element` instances as `nodes`. Therefore, each "top-level" node
          # will have its own collection of nodes.
          def cleanup(nodes:)
            nodes.each { |top_node| cleanup_top_node top_node }
            self
          end

          private

          def cleanup_top_node(top_node)
            top_node.nodes.each_with_index do |node, index|
              cleanup_contained_node top_node, node, index
            end
            top_node
          end

          def cleanup_contained_node(top_node, node, index)
            if node.respond_to?(:nodes)
              cleanup nodes: [node]
            else
              Internals.cleanup_detail_node top_node, index,
                                            top_node.nodes.count
            end
          end
        end # class Prolog::Services::MarkdownToHtml::Dumper::NodeCleanup
      end # class Prolog::Services::MarkdownToHtml::Dumper
    end # class Prolog::Services::MarkdownToHtml
  end
end
