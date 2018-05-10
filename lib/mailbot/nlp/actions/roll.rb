module Mailbot
  module NLP
    module Actions
      class Roll < Actions::Base
        def perform
          dice = args[:dice] || '1d20'

          result = Mailbot::Commands::Roll.new(user, [dice]).execute(context)

          # TODO: #execute called by both Command and Action
          result unless context.service
        end
      end
    end
  end
end
