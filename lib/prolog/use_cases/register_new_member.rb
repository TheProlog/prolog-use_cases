
require_relative 'register_new_member/attributes'

module Prolog
  module UseCases
    # Class encapsulating application logic for new-member registration.
    class RegisterNewMember
      # Class encapsulating application logic for new-member registration.
      class CurrentUserListener
        attr_reader :current_user_name

        def current_user_is(user_name)
          @current_user_name = user_name
          self
        end
      end # class Prolog::UseCases::RegisterNewMember::CurrentUserListener

      private_constant :Attributes, :CurrentUserListener
      include Wisper::Publisher

      def call(**params)
        @attributes = Attributes.new params
        verify_not_logged_in
        # Do stuff
        self
      end

      private

      attr_reader :attributes

      def already_logged_in?
        listener = CurrentUserListener.new
        Wisper.subscribe(listener) do
          broadcast :current_user
        end
        listener.current_user_name != 'Guest User'
      end

      def report_not_guest_user
        broadcast :failure, :already_logged_in
        self
      end

      def verify_not_logged_in
        return report_not_guest_user if already_logged_in?
        yield if block_given?
        self
      end
    end # class Prolog::UseCases::RegisterNewMember
  end
end
