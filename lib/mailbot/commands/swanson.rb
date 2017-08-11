module Mailbot
  module Commands
    class Swanson
      API_URL = "http://ron-swanson-quotes.herokuapp.com/v2/quotes"

      attr_reader :user, :args

      # @param [User] user The instance of a user
      # @param [Array<String>] args
      def initialize(user, args)
        @user = user
        @args = args
      end

      def execute(context)
        quote = JSON.parse(HTTParty.get(API_URL).body).first
        context.send_string("\"#{quote}\" - Ron Swanson")
      end
    end
  end
end