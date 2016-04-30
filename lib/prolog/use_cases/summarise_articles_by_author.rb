# frozen_string_literal: true

module Prolog
  module UseCases
    # Just what it says on the tin: like SummariseContent for a single Author.
    class SummariseArticlesByAuthor
      def initialize(authoriser:, repository:)
        @authoriser = authoriser
        @repository = repository
        self
      end

      # The `#call` method returns a Hash that is somewhat different than the
      # return value from `SummariseContent#call`. This reflects that the author
      # in question may have published no articles and that, while users other
      # than the author will receive a summary of only *published* articles, the
      # author himself should receive a summary including any saved drafts that
      # he may have created.
      #
      # * `:articles` references an array of all `Article` entities which the
      #   persistence subsystem (or "port") makes available. It is entirely
      #   plausible that this list might be empty; if it is, then the
      #   `:keywords_by_frequency` entry (below) will reference an empty array
      #   as well;.
      # * `:keywords_by_frequency` references a Hash whose keys are integers and
      #   whose values are arrays of strings. The value strings, collectively,
      #   include all keywords defined in all `:articles` by the specified
      #   author; each keyword occurs a total number of times (in the author's
      #   articles) matching the index of the hash entry in which it occurs.
      #   For example, a keyword "dunsel" that occurs 6 times in total would be
      #   part of the array referenced by `result[:keywords_by_frequency][6]`,
      #   where `result` was the return value from `#call`. Again, if the author
      #   specified in the parameter to `#call` has published no articles (or
      #   drafted none, in the case where this is being called by the current
      #   user), this will be an empty hash.
      #
      # No entries for `:most_recent_articles` or for
      # `:most_recently_updated_articles` are supplied here, contrary to the
      # example set by the initial implementation of `SummariseContent`, as we
      # have realised that the caller of this method is perfectly capable of
      # doing its own sorting *if needed*.
      #
      # Also note that there is no error reporting; any errors that do not cause
      # the code to fail outright will return empty arrays for `:articles` and
      # `:keywords`.
      def call(author_name:)
        load_article_list(author_name)
        build_return_hash
      end

      private

      attr_reader :authoriser, :repository

      def build_return_hash
      end

      def load_article_list(_author_name)
      end
    end # class Prolog::UseCases::SummariseArticlesByAuthor
  end
end
