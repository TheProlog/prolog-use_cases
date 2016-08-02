# frozen_string_literal: true

require 'prolog/support/dry_types_setup'

module Prolog
  module Entities
    # Required attributes to uniquely identify an Article.
    class ArticleIdentV < ::Dry::Types::Value
      attribute :author_name, String # FIXME: Constrained?
      attribute :title, String

      def to_s
        YAML.dump(to_hash)
      end
    end # class Prolog::Entities::ArticleIdentV
  end
end
