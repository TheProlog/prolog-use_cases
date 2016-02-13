
require_relative 'register_new_member/attributes'

module Prolog
  module UseCases
    # Class encapsulating application logic for new-member registration.
    class RegisterNewMember
      private_constant :Attributes

      def call(**params)
        @attributes = Attributes.new params
        # Do stuff
        self
      end
    end # class Prolog::UseCases::RegisterNewMember
  end
end
