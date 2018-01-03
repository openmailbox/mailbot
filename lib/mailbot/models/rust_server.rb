module Mailbot
  module Models
    class RustServer < ActiveRecord::Base
      attr_reader :client

      # @param [Hash] message The incoming message from the websocket
      def receive_message(message)
        puts message
      end

      def send(command)
        msg = message(command)

        if @client
          client.send(msg)
        else
          @client = init_websocket(msg)
        end
      end

      private

      def init_websocket(initial_message = nil)
        WebSocket::Client::Simple.connect "ws://#{ip}:#{rcon_port}/#{rcon_password}" do |ws|
          ws.on(:message) do |msg|
            if msg.type == :ping
              ws.send(nil, type: :pong)
            else
              model = ::Mailbot::Models::RustServer.find_by(ip: ws.handshake.host, rcon_port: ws.handshake.port)
              model.receive_message(JSON.parse(msg.data))
            end
          end

          ws.on(:open) do
            Mailbot.logger.info("Initialized websocket connection to RCon server @ #{ws.handshake.host}:#{ws.handshake.port}")
            initial_message && ws.send(initial_message)
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
        { Identifier: 1,
          Message: msg,
          Name: 'WebRcon'
        }.to_json
      end
    end
  end
end
