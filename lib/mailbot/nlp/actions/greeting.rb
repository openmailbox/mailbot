module Mailbot
  module NLP
    module Actions
      class Greeting < Actions::Base
        def perform
          "Hello, #{user.name}"
        end
      end
    end
  end
end
