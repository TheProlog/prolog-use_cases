# frozen_string_literal: true

require 'prolog/entities/result/base'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Reports results from execution of `#call` method.
      class Result < Prolog::Entities::Result::Base
        attribute :article, Types::Class
        attribute :contribution, Types::Class
      end # class Prolog::UseCases::ProposeEditContribution::Result
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
