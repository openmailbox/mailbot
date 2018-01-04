module Mailbot
  module Commands
    class Rust < Mailbot::Commands::Base
      enable_platform :twitch
      enable_platform :discord

      def perform
        return unless server

        return Rust::Status.new(self).execute unless args.any?

        case args.first.strip
        when 'help'
          help
        when 'drop'
          Rust::Drop.new(self).execute
        else
          "Unrecognized command. Try '!rust help'."
        end
      end

      def server
        @server ||= context.service && context.service.rust_servers.first
      end

      private

      def help
        text = 'Available Rust commands: '
        text << "'!rust' shows the current server status. "
        text << "'!rust drop' calls in a supply drop (#{Rust::Drop::COOLDOWN} min cooldown)."
      end
    end
  end
end
