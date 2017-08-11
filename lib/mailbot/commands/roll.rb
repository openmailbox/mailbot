module Mailbot
  module Commands
    class Roll < Mailbot::Commands::Base
      def perform
        match = args.any? && args.first.match(/^(\d+)d(\d+)$/)

        return "Invalid roll command. Try '!roll 1d20' or '!roll 4d8'." unless match

        d1 = match[1].to_i
        d2 = match[2].to_i

        return "I'm sorry, Dave. I'm afraid I can't do that." if d1 > 100 || d2 > 100

        result = (1..d1).inject(0) { |i| i += rand(d2) + 1 }

        "#{user.name} rolls #{match[0]} and gets #{result}!"
      end
    end
  end
end
