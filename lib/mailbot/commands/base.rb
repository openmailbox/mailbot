module Mailbot
  module Commands
    class Base
      attr_reader :user, :args, :context

      # @param [User] user The instance of a user
      # @param [Array<String>] args
      def initialize(user, args)
        @user = user
        @args = args
      end

      # @param [Context] context The contextual information about this command execution
      #
      # @return [String, nil] The message sent back to the user or nil if there is none
      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - #{command_name} #{args}"

        @context = context
        result   = perform

        result && context.send_string(result)
      end

      protected

      def perform
        raise NotImplementedError.new("Subclasses must implement #perform.")
      end

      private

      def command_name
        self.class.to_s.split('::').last.downcase
      end
    end
  end
end
