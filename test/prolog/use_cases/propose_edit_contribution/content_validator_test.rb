
require 'test_helper'

require 'prolog/use_cases/propose_edit_contribution/content_validator'

describe 'Prolog::UseCases::ProposeEditContribution::ContentValidator' do
  let(:described_class) do
    Prolog::UseCases::ProposeEditContribution::ContentValidator
  end

  describe 'initialisation takes three required parameters, with' do
    let(:params) do
      described_class.new(nil, nil, nil).method(:initialize).parameters
    end

    it 'the first as :ui_gateway' do
      expect(params[0]).must_equal [:req, :ui_gateway]
    end

    it 'the second as :user_name' do
      expect(params[1]).must_equal [:req, :user_name]
    end

    it 'the third as :article_id' do
      expect(params[2]).must_equal [:req, :article_id]
    end
  end # describe 'initialisation takes three required parameters, with'

  describe 'has an #invalid? method that' do
    let(:obj) { described_class.new ui_gateway, user_name, article_id }
    let(:article_id) { 'the article id goes here' }
    let(:author_name) { 'Jonathan Swift' }
    let(:title) { 'On the Conduct of the Allies' }
    let(:ui_gateway) do
      Class.new do
        attr_accessor :method_calls

        def initialize
          @method_calls = []
        end

        #        ######     #    #     #  #####  ####### ######
        #        #     #   # #   ##    # #     # #       #     #
        #        #     #  #   #  # #   # #       #       #     #
        #        #     # #     # #  #  # #  #### #####   ######
        #        #     # ####### #   # # #     # #       #   #   ###
        #        #     # #     # #    ## #     # #       #    #  ###
        #        ######  #     # #     #  #####  ####### #     #  #
        #                                                        #
        #                    #     # ### #       #
        #                    #  #  #  #  #       #
        #                    #  #  #  #  #       #
        #                    #  #  #  #  #       #
        #                    #  #  #  #  #       #
        #                    #  #  #  #  #       #
        #                     ## ##  ### ####### #######
        #
        #  ######  ####### ######  ### #     #  #####  ####### #     # ###
        #  #     # #     # #     #  #  ##    # #     # #     # ##    # ###
        #  #     # #     # #     #  #  # #   # #       #     # # #   # ###
        #  ######  #     # ######   #  #  #  #  #####  #     # #  #  #  #
        #  #   #   #     # #     #  #  #   # #       # #     # #   # #
        #  #    #  #     # #     #  #  #    ## #     # #     # #    ## ###
        #  #     # ####### ######  ### #     #  #####  ####### #     # ###

        # This version of #method_missing and of #respond_to? will allow *any*
        # method call, with *any* parameters, and do absolutely nothing (except
        # return a facetious symbol). *DO NOT* even *think* of doing this in
        # production code!

        def method_missing(method, *args, &block)
          @method_calls << [method, args, block]
          # super
          :this_does_nothing
        end

        def respond_to?(_method, _include_private = false)
          true
        end
      end.new
    end
    let(:user_name) { 'John Doe' }

    it 'takes one required parameter, :content' do
      params = obj.method(:invalid?).parameters
      expect(params).must_equal [[:req, :content]]
    end

    describe 'when called with a string that is' do
      describe 'not empty' do
        before { @ret = obj.invalid? 'content' }

        it 'returns false' do
          expect(@ret).must_equal false
        end

        it 'does not call any method on the UI Gateway object' do
          expect(ui_gateway.method_calls).must_be :empty?
        end
      end # describe 'not empty'

      describe 'empty' do
        before { @ret = obj.invalid? '' }

        it 'returns true' do
          expect(@ret).must_equal true
        end

        describe 'calls the ui_gateway#failure method' do
          let(:failure_data) { ui_gateway.method_calls.first }

          it 'once' do
            expect(ui_gateway.method_calls.count).must_equal 1
            expect(failure_data.first).must_equal :failure
          end

          describe 'with a JSON-encoded payload including' do
            let(:payload) do
              JSON.parse ui_gateway.method_calls.first[1].first,
                         symbolize_names: true
            end

            it 'a :failure field of "empty proposed content"' do
              expect(payload[:failure]).must_equal 'empty proposed content'
            end

            it 'a :member_name field with the member name' do
              expect(payload[:member_name]).must_equal user_name
            end

            it 'an :article_ident field matching what was passed in' do
              expect(payload[:article_id]).must_equal article_id.to_s
            end
          end # describe 'with a JSON-encoded payload including'
        end # describe 'calls the ui_gateway#failure method'
      end # describe 'empty'

      describe 'blank' do
        before { @ret = obj.invalid? '     ' }

        it 'returns true' do
          expect(@ret).must_equal true
        end

        describe 'calls the ui_gateway#failure method' do
          let(:failure_data) { ui_gateway.method_calls.first }

          it 'once' do
            expect(ui_gateway.method_calls.count).must_equal 1
            expect(failure_data.first).must_equal :failure
          end

          describe 'with a JSON-encoded payload including' do
            let(:payload) do
              JSON.parse ui_gateway.method_calls.first[1].first,
                         symbolize_names: true
            end

            it 'a :failure field of "blank proposed content"' do
              expect(payload[:failure]).must_equal 'blank proposed content'
            end

            it 'a :member_name field with the member name' do
              expect(payload[:member_name]).must_equal user_name
            end

            it 'an :article_ident field matching what was passed in' do
              expect(payload[:article_id]).must_equal article_id.to_s
            end
          end # describe 'with a JSON-encoded payload including'
        end # describe 'calls the ui_gateway#failure method'
      end # describe 'blank'

      describe 'missing' do
        before { @ret = obj.invalid? nil }

        it 'returns true' do
          expect(@ret).must_equal true
        end

        describe 'calls the ui_gateway#failure method' do
          let(:failure_data) { ui_gateway.method_calls.first }

          it 'once' do
            expect(ui_gateway.method_calls.count).must_equal 1
            expect(failure_data.first).must_equal :failure
          end

          describe 'with a JSON-encoded payload including' do
            let(:payload) do
              JSON.parse ui_gateway.method_calls.first[1].first,
                         symbolize_names: true
            end

            it 'a :failure field of "missing proposed content"' do
              expect(payload[:failure]).must_equal 'missing proposed content'
            end

            it 'a :member_name field with the member name' do
              expect(payload[:member_name]).must_equal user_name
            end

            it 'an :article_ident field matching what was passed in' do
              expect(payload[:article_id]).must_equal article_id.to_s
            end
          end # describe 'with a JSON-encoded payload including'
        end # describe 'calls the ui_gateway#failure method'
      end # describe 'missing'
    end # describe 'when called with a string that is'
  end # describe 'has an #invalid? method that'
end
