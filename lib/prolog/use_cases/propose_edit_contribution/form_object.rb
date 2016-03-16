
require 'forwardable'

require 'virtus'

require_relative 'repo_client'

module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    class ProposeEditContribution
      # Attribute collection and (eventual) validation support.
      class FormObject
        include Virtus.model
        extend Forwardable

        attribute :article_ident, Object
        attribute :article_repo, Object
        attribute :authoriser, Object
        attribute :contribution_repo, Object
        attribute :proposed_content, String, default: '** PROPOSED CONTENT? **'
        attribute :markdown_converter, Object,
                  default: -> (_, _) { Prolog::Services::MarkdownToHtml.new }
        attribute :endpoints, Range
        attribute :justification, String

        def article
          return @article if @article
          repo = RepoClient.new(article_repo)
          @article = repo.find_first article_ident.to_h
        end

        delegate current_user: :authoriser

        delegate last_contribution_id: :contribution_repo

        def proposed_content=(new_content)
          markup = markdown_converter.call(content: new_content).content
          super markup
        end
      end # class Prolog::UseCases::ProposeEditContribution::FormObject
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
