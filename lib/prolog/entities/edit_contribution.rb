
require 'virtus'

require 'prolog/support/form_object/integer_range'

require_relative 'article_ident'

module Prolog
  module Entities
    # Edit-contribution data attributes as a value object.
    class EditContribution
      include Virtus.value_object(strict: true)
      include Prolog::Support::FormObject

      values do
        attribute :article_id, ArticleIdent
        attribute :endpoints, IntegerRange
        attribute :justification, String, default: ''
        attribute :proposed_content, String
        attribute :proposer_name, String
      end
    end # class Prolog::Entities::EditContribution
  end
end
