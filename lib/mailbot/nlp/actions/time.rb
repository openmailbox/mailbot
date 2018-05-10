module Mailbot
  module NLP
    module Actions
      class Time < Actions::Base
        def perform
          "The current time is #{DateTime.now}."
        end
      end
    end
  end
end
