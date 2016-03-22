
require 'virtus'

module Prolog
  module Entities
    # Required attributes to uniquely identify an Article.
    class ArticleIdent
      include Virtus.value_object(strict: true)

      values do
        attribute :author_name, String
        attribute :title, String
      end

      def to_s
        YAML.dump attributes
      end
    end # class Prolog::Entities::ArticleIdent
  end
end
