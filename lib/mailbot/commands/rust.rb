module Mailbot
  module Commands
    class Rust < Mailbot::Commands::Base
      enable_platform :twitch
      enable_platform :discord

      def perform
        return unless server

        Rust::Status.new(self).execute unless args.any?
      end

      def server
        @server ||= context.service && context.service.rust_servers.first
      end
    end
  end
end
