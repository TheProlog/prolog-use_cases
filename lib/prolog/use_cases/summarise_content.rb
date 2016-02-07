
require 'forwardable'

require_relative 'summarise_content/article_lister.rb'

module Prolog
  module UseCases
    # Class to summarise content of landing page or equivalent. This includes,
    # but is notlimited to, a list of most-recent articles.
    class SummariseContent
      private_constant :ArticleLister
      extend Forwardable
      include Wisper::Publisher

      def_delegators :@article_list, :articles

      def call
        load_article_list
      end

      private

      attr_reader :article_list

      def load_article_list
        @article_list = ArticleLister.new broadcast: method(:broadcast)
        article_list.call
        self
      end
    end # class Prolog::UseCases::SummariseContent
  end
end
