
# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Defines our two-stage initialisation of the form object. The first step
      # is to be called from the use case `#initialize` method; the second, from
      # the beginning of `#call`.
      class FormObjectTwoStage
        def self.init(article, authoriser)
          FormObject.new(article: article, guest: authoriser.guest?,
                         user_name: authoriser.user_name)
        end

        # No, this doesn't have much in the way of added value, except for
        # grouping the second "stage" of initialisation into one place.
        def self.update(fo, endpoints, proposed_content, justification)
          fo.endpoints = endpoints
          fo.justification = justification
          fo.proposed_content = proposed_content
        end
      end # class Prolog::UseCases::ProposeEditContribution::FormObjectTwoStage
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
