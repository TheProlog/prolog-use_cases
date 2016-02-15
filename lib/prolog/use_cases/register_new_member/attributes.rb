
require 'forwardable'

require 'virtus'

module Prolog
  module UseCases
    # Class encapsulating application logic for new-member registration.
    class RegisterNewMember
      # Wrapper for attributes value object, to contain wonky initialisation.
      class Attributes
        # Value object containing (read-only) attributes supplied to #call.
        class Values
          include Virtus.value_object

          values do
            attribute :name, String
            attribute :email, String
            attribute :profile, String
            attribute :password, String
            attribute :confirmation, String
          end
        end # class Prolog::UseCases::RegisterNewMember::attributes::Values

        extend Forwardable
        def_delegators :@values, :name, :email, :profile, :password,
                       :confirmation

        def initialize(**params)
          @values = Values.new params
          fail_omissions params, :name, :email, :password, :confirmation
        end

        def ==(other)
          values == other.values
        end

        protected

        attr_reader :values

        private

        def fail_omissions(params, *symbols)
          symbols.each do |attrib|
            next if params[attrib]
            fail KeyError, "key not found: :#{attrib}"
          end
          self
        end
      end # class Prolog::UseCases::RegisterNewMember::Attributes
    end # class Prolog::UseCases::RegisterNewMember
  end
end
