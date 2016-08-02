# frozen_string_literal: true

require 'test_helper'

require 'uuid'

require 'prolog/use_cases/propose_edit_contribution/attributes'

describe 'Prolog::UseCases::ProposeEditContribution::Attributes' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::Attributes
  end
  let(:article) do
    Struct.new(:author_name, :body, :title).new author_name, body, title
  end
  let(:author_name) { 'j Random Author' }
  let(:body) { '<p>This is an Article body.</p>' }
  let(:endpoints) do
    ep_begin = body.index 'an Article'
    ep_end = body.index '</p>'
    (ep_begin...ep_end)
  end
  let(:identifier) { nil }
  let(:justification) { 'Just because.' }
  let(:proposed_at) { nil } # use default value
  let(:proposer) { 'P Random Member' }
  let(:proposed_content) { 'updated content.' }
  let(:title) { 'A Title' }
  let(:obj) { described_class.new params }
  let(:params) do
    { article: article, endpoints: endpoints, justification: justification,
      proposed_content: proposed_content, proposed_at: proposed_at,
      proposer: proposer, identifier: identifier }
  end
  let(:original_content) { obj.article.body[endpoints] }

  describe 'initialisation' do
    describe 'with a complete set of valid parameters' do
      it 'succeeds' do
        expect(described_class.new params).must_be_instance_of described_class
      end
    end # describe 'with a complete set of valid parameters'

    describe 'supplies expected default values for omitted parameters for' do
      it ':justification' do
        params[:justification] = nil
        expect(obj.justification).must_equal ''
      end

      it ':endpoints' do
        params[:endpoints] = nil
        expected = (0..0)
        expect(obj.endpoints).must_equal expected
      end
    end # describe 'supplies expected default values for omitted parameters for'
  end # describe ';nitialisation'

  describe 'has an #article_id method that' do
    let(:article_id) { obj.article_id }

    it 'returns a Hash-like object' do
      expect(article_id).must_respond_to :to_hash
    end

    describe 'has hash entries for' do
      it ':author_name' do
        expect(article_id[:author_name]).must_equal author_name
      end

      it ':title' do
        expect(article_id[:title]).must_equal title
      end
    end # describe 'has hash entries for'

    describe 'has Struct-like reader methods for' do
      it ':author_name' do
        expect(article_id.author_name).must_equal author_name
      end

      it ':title' do
        expect(article_id.title).must_equal title
      end
    end # describe 'has Struct-like reader methods for'
  end # describe 'has an #article_id method that'

  it 'has an :original_content attribute reader returning expected content' do
    expect(obj.original_content).must_equal original_content
  end

  describe 'has a #to_hash method returning correct entries for' do
    it ':original_content' do
      expect(obj[:original_content]).must_equal original_content
    end
  end # describe 'has a #to_hash method returning correct entries for'
end
