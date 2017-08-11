module Mailbot
  module Commands
    class Swanson < Mailbot::Commands::Base
      API_URL = "http://ron-swanson-quotes.herokuapp.com/v2/quotes"

      enable_platform :twitch
      enable_platform :discord

      def perform
        quote = JSON.parse(HTTParty.get(API_URL).body).first

        "\"#{quote}\" - Ron Swanson"
      end
    end
  end
end
