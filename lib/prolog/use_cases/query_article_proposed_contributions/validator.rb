# frozen_string_literal: true

require_relative 'verify_article_exists'
require_relative 'verify_authentication'
require_relative 'verify_user_is_author'

module Prolog
  module UseCases
    # Queries for Contribution Proposals that have been submitted but not yet
    # Responded to, that are Proposed against an Article published by the
    # currently loggedd-in Member.
    class QueryArticleProposedContributions
      # Runs validation steps for use case.
      class Validator
        def self.call(article_id:, article_repo:, authoriser:)
          Validator.new(article_repo, authoriser).call article_id
        end

        def call(article_id)
          @article_id = article_id
          errors
        end

        protected

        def initialize(article_repo, authoriser)
          @article_repo = article_repo
          @authoriser = authoriser
          self
        end

        private

        attr_reader :article_id, :article_repo, :authoriser

        def all_errors
          verify_with_params.reject(&:empty?)
        end

        def errors
          [first_error].reject(&:nil?)
        end

        def first_error
          all_errors.first
        end

        def params
          { article_id: article_id, article_repo: article_repo,
            authoriser: authoriser }
        end

        def verify_with_params
          Internals.verify_with_params params
        end

        # Methods that neither depend on nor affect instance state.
        module Internals
          def self.article_verifier
            proc do |params|
              VerifyArticleExists.call params[:article_id],
                                       params[:article_repo]
            end
          end

          def self.auth_verifier
            ->(params) { VerifyAuthentication.call params[:authoriser] }
          end

          def self.author_verifier
            proc do |params|
              VerifyUserIsAuthor.call params[:authoriser], params[:article_id]
            end
          end

          def self.verifiers
            [auth_verifier, author_verifier, article_verifier]
          end

          def self.verify_with_params(params)
            verifiers.map { |verifier| verifier.call params }
          end
        end
        private_constant :Internals
      end # class Prolog::UseCases::QueryArticleProposedContributions::Validator
    end # class Prolog::UseCases::QueryArticleProposedContributions
  end
end
