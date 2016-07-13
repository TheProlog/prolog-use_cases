# frozen_string_literal: true

require 'prolog/entities/result/base'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Result notification encapsulation for query.
      class Result < Prolog::Entities::Result::Base
        attribute :proposals, Types::Strict::Array
      end # class Prolog::UseCases::QueryArticleProposedContributions::Result
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
