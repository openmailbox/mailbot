module Mailbot
  module NLP
    module Actions
      class Base
        attr_reader :user, :args, :context

        def self.action_name
          self.name.to_s.split('::').last.downcase
        end

        # @param [User] user The instance of a user
        # @param [Hash<Symbol,String>] args Parsed intent arguments
        def initialize(user, args)
          @user = user
          @args = args
        end

        # @param [Context] context The contextual information about this command execution
        #
        # @return [String, nil] The message sent back to the user or nil if there is none
        def execute(context)
          Mailbot.logger.info "USER COMMAND: #{user.name} - #{self.class.action_name} #{args}"

          @context = context
          result   = perform

          result && context.send_string(result.to_s)
        end

        protected

        def perform
          raise NotImplementedError.new('Subclasses must implement #perform.')
        end
      end
    end
  end
end
