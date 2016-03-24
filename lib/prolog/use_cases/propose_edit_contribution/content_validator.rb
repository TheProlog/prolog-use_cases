
# "Propose Edit Contribution" use case.
module Prolog
  module UseCases
    # Use case encapsulating all domain logic involved in submitting a proposal
    # for an Edit Contribution.
    # Reek says this class smells of :reek:TooManyInstanceVariables; we'll worry
    # about that sometime in The Glorious Future.
    class ProposeEditContribution
      # Class to validate proposed content and complain if invalid.
      class ContentValidator
        def initialize(ui_gateway, user_name, article_id)
          @ui_gateway = ui_gateway
          @user_name = user_name
          @article_id = article_id
          self
        end

        def invalid?(content)
          return false unless content.to_s.strip.empty?
          @content = content
          @ui_gateway.failure invalid_content_payload
          true
        end

        private

        def invalid_content_payload
          { failure: invalid_content_reason, member_name: @user_name,
            article_id: @article_id }.to_json
        end

        # Reek doesn't like :reek:NilCheck; too bad.
        def invalid_content_reason
          case @content
          when nil then 'missing proposed content'
          when /\A\s+\z/ then 'blank proposed content'
          when '' then 'empty proposed content'
            # else "unknown invalid proposed content: '#{@content}'"
          end
        end
      end # class Prolog::UseCases::ProposeEditContribution::ContentValidator
    end # class Prolog::UseCases::ProposeEditContribution
  end
end
