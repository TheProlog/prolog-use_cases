
require 'test_helper'

require 'prolog/use_cases/summarise_content/article_lister'

describe 'Prolog::UseCases::SummariseContent::ArticleLister' do
  let(:described_class) { Prolog::UseCases::SummariseContent::ArticleLister }
  let(:obj) { described_class.new repository: repository }

  it 'must be initialised with a :repository named parameter' do
    error = expect { described_class.new }.must_raise ArgumentError
    expect(error.message).must_equal 'missing keyword: repository'
  end

  describe 'has a #call method that' do
    let(:payload) { [1, 2, 3] }
    let(:repository) do
      Struct.new(:all).new payload
    end

    it 'queries the repository using its #all method' do
      error = expect do
        described_class.new(repository: nil).call
      end.must_raise NoMethodError
      expect(error.message).must_match "undefined method `all' for"
    end

    it 'sets its :articles ivar based on that #all method' do
      expect(obj.articles).must_be :empty?
      obj.call
      expect(obj.articles).must_equal payload
    end
  end # describe 'has a #call method that'
end
