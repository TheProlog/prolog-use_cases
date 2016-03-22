
require 'virtus'

require 'prolog/support/form_object/integer_range'

require 'prolog/entities/article_ident'

module Prolog
  module Entities
    module EditContribution
      # Edit-contribution proposal data attributes as a value object.
      class Proposed
        include Virtus.value_object(strict: true)
        include Prolog::Support::FormObject # for IntegerRange

        values do
          attribute :article_id, ArticleIdent
          attribute :endpoints, IntegerRange
          attribute :justification, String, default: ''
          attribute :proposed_content, String
          attribute :user_name, String # formerly :proposer_name
          attribute :proposed_at, DateTime, default: -> (_, _) { DateTime.now }
        end
      end # class Prolog::Entities::EditContribution::Proposed
    end
  end
end
