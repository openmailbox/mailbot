module Mailbot
  module Commands
    class Base
      attr_reader :user, :args, :context

      def self.enabled_on?(name)
        @platforms ||= []
        !!@platforms.find { |i| i == name.to_sym }
      end

      def self.enable_platform(name)
        @platforms ||= []
        @platforms << name.to_sym
      end

      def self.command_name
        self.name.to_s.split('::').last.downcase
      end

      # @param [User] user The instance of a user
      # @param [Array<String>] args Command arguments
      def initialize(user, args)
        @user = user
        @args = args
      end

      # @param [Context] context The contextual information about this command execution
      #
      # @return [String, nil] The message sent back to the user or nil if there is none
      def execute(context)
        Mailbot.logger.info "USER COMMAND: #{user.name} - #{self.class.command_name} #{args}"

        @context = context
        result   = perform

        result && context.send_string(result.to_s)
      end

      protected

      # Subclasses implement this to define command behavior.
      #
      # @return [String, nil] Return the string to send back to the user or nil if not applicable.
      def perform
        raise NotImplementedError.new("Subclasses must implement #perform.")
      end
    end
  end
end
