module Mailbot
  module NLP
    module Actions
      class Roll < Actions::Base
        def perform
          dice = args[:dice] || '1d20'

          Mailbot::Commands::Roll.new(user, [dice]).execute(context)
        end
      end
    end
  end
end
