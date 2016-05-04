# frozen_string_literal: true

module MiniTest
  # Adding custom assertions to make specs easier to read
  module Assertions
    def assert_keywords_as_expected(obj, keywords, author_name, message = nil)
      message ||= "expected\n #{obj}\nto have sorted keywords\n #{keywords}"
      call_result = obj.call author_name: author_name
      assert call_result.keywords.to_a == keywords.to_a.sort, message
    end
  end

  # Make it available to MiniTest::Spec
  module Expectations
    infect_an_assertion :assert_keywords_as_expected,
                        :must_have_keywords_as_expected, :reverse
  end
end
