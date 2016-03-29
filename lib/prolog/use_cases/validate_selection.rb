
module Prolog
  module UseCases
    # Validate selection parameters for eventual Contribution proposal.
    class ValidateSelection
      def initialize(**params)
        @article = params.fetch :article
        self
      end
    end # class Prolog::UseCases::ValidateSelection
  end
end
