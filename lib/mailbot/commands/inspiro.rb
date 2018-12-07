module Mailbot
  module Commands
    class Inspiro < Mailbot::Commands::Base
      URL = 'https://inspirobot.me/api?generate=true'.freeze

      enable_platform :discord

      def perform
        result = nil

        open(URL) do |file|
          result = file.readline.chomp
        end

        result.to_s
      end
    end
  end
end
