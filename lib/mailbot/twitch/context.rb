module Mailbot
  class Twitch
    # Data structure representing a parsed/tokenized message from Twitch chat
    #
    # @attr_accessor [Mailbot::Models::User] user the user who sent the message
    # @attr_accessor [Mailbot::Models::Channel] channel the channel the message originated from
    # @attr_accessor [Object, #execute] command an object that responds to #execute from the Mailbot::Commands namespace
    class Context
      attr_accessor :user, :channel, :command

      # @param [String] message the message to send to @channel
      #
      # @return [nil]
      def send_string(message)
        channel.send_message(message)
      end
    end
  end
end
