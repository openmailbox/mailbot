module Mailbot
  module Models
    class RustServer < ActiveRecord::Base
      SERVER_TIMEOUT = 5 # seconds

      attr_reader :client, :buffer

      belongs_to :channel
      belongs_to :community

      # @param [String] command The command to send to the server
      #
      # @return [String, Hash] Returns the message identifier if non-blocking or the response otherwise
      def rcon(command, blocking: true, close_connection: true)
        msg        = message(command)
        identifier = msg[:Identifier]
        json       = msg.to_json

        if @client && @client.open?
          client.send(json)
        else
          @client && (@client.close if @client.open?)
          @client = init_websocket(json, close_connection: !blocking && close_connection)
        end

        return identifier unless blocking

        Timeout::timeout(SERVER_TIMEOUT) do
          loop do
            next_message = JSON.parse(buffer.pop)

            if next_message['Identifier'] == identifier
              @client.close if close_connection
              return next_message
            end
          end
        end
      end

      private

      def init_websocket(initial_message = nil, close_connection: false)
        @next_identifier = 1
        @buffer          = Queue.new
        model            = self # self changes inside the websocket thread

        WebSocket::Client::Simple.connect "ws://#{ip}:#{rcon_port}/#{rcon_password}" do |ws|
          ws.on(:message) do |msg|
            if msg.type == :ping
              ws.send(nil, type: :pong)
            else
              model.buffer.push(msg.data)
            end
          end

          ws.on(:open) do
            Mailbot.logger.info("Initialized websocket connection to RCon server @ #{ws.handshake.host}:#{ws.handshake.port}")
            initial_message && ws.send(initial_message)
            ws.close if close_connection
          end

          ws.on(:error) do |e|
            Mailbot.logger.warn("RCon websocket error: #{e}")
          end

          ws.on(:close) do |e|
            Mailbot.logger.info("RCon connection to #{ws.handshake.host}:#{ws.handshake.port} closed.")
          end
        end
      end

      def message(msg)
        {
          Identifier: next_identifier,
          Message:    msg,
          Name:       'WebRcon'
        }
      end

      def next_identifier
        @identifier ||= 1

        identifier = @identifier
        @identifier += 1

        identifier
      end
    end
  end
end
