# frozen_string_literal: true

require 'benchmark/ips'

require 'dry-types'

require_relative '../../../lib/prolog/use_cases/retrieve_article'

class RepoDummy
  def initialize(result:)
    @result = result
    @called_with = []
  end

  def find(**_params)
    [@result].flatten.freeze
  end
end

module Types
  include Dry::Types.module
end

class ArticleValue < Dry::Types::Value
  attribute :author_name, ::Types::Strict::String
  attribute :body, ::Types::Strict::String
  attribute :image_url, ::Types::Strict::String
  attribute :keywords, ::Types::Strict::Array.member(Types::Coercible::String)
  attribute :title, ::Types::Strict::String
end

Benchmark.ips do |x|
  dummy_article_class = Struct.new(:title, :body, :image_url, :keywords,
                                   :author_name)
  author_name = 'Author Name'
  body_text = 'Body Text'
  image_url = 'http://www.example.com/image1.png'
  keywords = []
  title = 'Sample Title'
  dummy_article = dummy_article_class.new(title, body_text, image_url, keywords,
                                          author_name).freeze
  #
  repository = RepoDummy.new result: [dummy_article]
  params = { title: title, author: author_name, repository: repository }
  authoriser = Struct.new(:guest?, :current_user).new false, 'User Name'
  init_params = { repository: repository, authoriser: authoriser }
  # obj = Prolog::UseCases::RetrieveArticle.new init_params
  # ret = obj.call params

  x.report 'original, 1 article' do
    Prolog::UseCases::RetrieveArticle.new(init_params).call params
  end

  da_params = { author_name: author_name, body: body_text, image_url: image_url,
                keywords: keywords, title: title }
  dummy_article = ArticleValue.new da_params
  params[:repository] = RepoDummy.new(result: [dummy_article])
  init_params[:repository] = params[:repository]

  x.report 'values, 1 article' do
    Prolog::UseCases::RetrieveArticle.new(init_params).call params
  end

  params[:repository] = RepoDummy.new(result: [])
  init_params[:repository] = params[:repository]
  x.report 'no articles' do
    Prolog::UseCases::RetrieveArticle.new(init_params).call params
  end

  x.compare!
end
