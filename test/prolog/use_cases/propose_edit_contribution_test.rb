
require 'test_helper'

require 'prolog/services/markdown_to_html'
require 'prolog/use_cases/propose_edit_contribution'

# :reek:TooManyStatements: and :reek:FeatureEnvy: -- as if we care here.
def markdown_service_with_counter
  service = Prolog::Services::MarkdownToHtml.new
  service.instance_variable_set :@old_call, service.method(:call)
  service.instance_variable_set :@counter, 0
  service.define_singleton_method :call do |content:|
    @counter += 1
    @old_call.call content: content
  end
  service.class.instance_eval { attr_reader :counter }
  service
end

describe 'Prolog::UseCases::ProposeEditContribution' do
  let(:described_class) { Prolog::UseCases::ProposeEditContribution }
  let(:article_repo) { Object.new }
  let(:authoriser) { Object.new }
  let(:contribution_repo) { Object.new }
  let(:init_params) do
    { article_repo: article_repo, authoriser: authoriser,
      contribution_repo: contribution_repo }
  end
  let(:obj) { described_class.new init_params }

  it 'may not be initialised without arguments' do
    expect { described_class.new }.must_raise ArgumentError
  end

  describe 'must be initialised with parameters for' do
    after do
      init_params.delete @param
      expected = ArgumentError
      error = expect { described_class.new init_params }.must_raise expected
      expect(error.message).must_match @param.to_s
    end

    it ':article_repo' do
      @param = :article_repo
    end

    it ':authoriser' do
      @param = :authoriser
    end

    it ':contribution_repo' do
      @param = :contribution_repo
    end
  end # describe 'must be initialised with parameters for'

  describe 'has a #call method that' do
    let(:call_params) do
      { article_ident: article_ident, endpoints: endpoints,
        justification: justification, proposed_content: proposed_content }
    end
    let(:article_ident) do
      Struct.new(:author_name, :title).new author_name, article_title
    end
    let(:article) do
      articlass = Struct.new(:author_name, :body, :title)
      articlass.new author_name, article_body, article_title
    end
    let(:article_repo) do
      Class.new do
        attr_reader :article, :calls

        def initialize(article)
          @article = article
          @calls = []
        end

        def find(**params)
          @calls << params
          [article]
        end
      end.new(article)
    end
    let(:article_body) do
      "This is *original*, not ~imitation~ content.\nDeal with it."
    end
    let(:article_title) { 'An Article With a Title' }
    let(:author_name) { 'J Random Author' }
    let(:authoriser) do
      Class.new do
        attr_reader :current_user_count, :current_user_name

        def initialize(current_user_name)
          @current_user_name = current_user_name
          @current_user_count = 0
          self
        end

        def current_user
          @current_user_count += 1
          current_user_name
        end
      end.new current_user_name
    end
    let(:contribution_repo) do
      Class.new do
        attr_reader :calls

        def initialize(last_contribution_id)
          @last_contribution_id = last_contribution_id
          @calls = 0
        end

        def last_contribution_id
          @calls += 1
          @last_contribution_id
        end
      end.new last_contribution_id
    end
    let(:current_user_name) { 'J Random User' }
    let(:endpoints) { Object.new }
    let(:justification) { Object.new }
    let(:last_contribution_id) { rand(999) }
    let(:proposed_content) do
      'This is *proposed* content. That is **all for now**.'
    end

    describe 'must be called with parameters for' do
      after do
        call_params.delete @param
        error = expect { obj.call call_params }.must_raise ArgumentError
        expect(error.message).must_match @param.to_s
      end

      it ':article_identifer' do
        @param = :article_ident
      end

      it ':endpoints' do
        @param = :endpoints
      end

      it ':justification' do
        @param = :justification
      end

      it ':proposed_content' do
        @param = :proposed_content
      end
    end # describe 'must be called with parameters for'

    describe 'when called with a complete set of valid parameters' do
      before { obj.call call_params }

      describe 'queries the Article Repository' do
        it 'once' do
          expect(article_repo.calls.count).must_equal 1
        end

        it 'with the author name and title expected' do
          expect(article_repo.calls.first).must_equal article_ident.to_h
        end
      end # describe 'queries the Article Repository'

      describe 'queries the Authoriser for' do
        it 'the current Member name' do
          expect(authoriser.current_user_count).must_equal 1
        end
      end # describe 'queries the Authoriser for'

      describe 'queries the Contribution Repository for' do
        it 'the last Contribution ID' do
          expect(contribution_repo.calls).must_equal 1
        end
      end # describe 'queries the Contribution Repository for'

      it 'calls the service to convert replacement content to HTML' do
        subject_class = Prolog::UseCases::ProposeEditContributionTestEnhancer
        obj = subject_class.new init_params
        obj.markdown_converter = markdown_service_with_counter
        expect(obj.markdown_converter.counter).must_be :zero?
        obj.call call_params
        expect(obj.markdown_converter.counter).wont_be :zero?
      end

      describe 'uses Selection Service to update Article body based on' do
        it 'the existing body markup'

        it 'the proposed replacement markup (as HTML)'

        it 'the last-contribution ID'
      end # describe 'uses Selection Service to update Article body based on'

      describe 'adds a new entry to the Contribution Repository, including' do
        it 'the identification of the Article'

        it 'the name of the Member proposing the Contribution'

        it 'the endpoints of the existing markup proposed for replacement'

        # Belt, meet suspenders.
        it 'the markup text proposed for replacement'

        it 'the proposed updated body markup'

        it 'the contribution-ID sequence number'

        it 'the supplied justification content (as Markdown)'

        describe 'when proposed by a Member other than the Author' do
          it 'sets the state of the new entry to "proposed"'
        end # describe 'when proposed by a Member other than the Author'

        describe 'when proposed by the Article Author' do
          it 'sets the state of the new entry to "accepted"'
        end # describe 'when proposed by the Article Author'
      end # describe 'adds a new entry to the Contribution Repository'

      describe 'when proposed by a Member other than the Author' do
        describe 'does not update the fields in the Article entity for' do
          it 'body'

          it 'last-updated-at timestamp'
        end # describe 'does not update the fields in the Article entity for'
      end # describe 'when proposed by a Member other than the Author'

      describe 'when proposed by the Article Author' do
        describe 'correctly updates the fields in the Article entity for' do
          it 'body'

          it 'last-updated-at timestamp'
        end # describe 'correctly updates the fields in the Article entity for'
      end # describe 'when proposed by the Article Author'
    end # describe 'when called with a complete set of valid parameters, it'
  end # describe 'has a #call method that'
end # Prolog::UseCases::ProposeEditContribution
