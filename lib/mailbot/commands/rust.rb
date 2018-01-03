module Mailbot
  module Commands
    class Rust < Mailbot::Commands::Base
      SUPPLY_COOLDOWN = 20 # minutes
      HELI_COOLDOWN   = 30 # minutes

      enable_platform :twitch
      enable_platform :discord

      def perform
        return unless server

        return Rust::Status.new(self).execute unless args.any?

        case args.first.strip
        when 'help'
          help
        when 'supply'
          callin('supply drop', 'supply.call', server.last_supply_at, SUPPLY_COOLDOWN)
        when 'heli'
          callin('attack helicopter', 'heli.call', server.last_heli_at, HELI_COOLDOWN)
        else
          "Unrecognized command. Try '!rust help'."
        end
      end

      def server
        @server ||= context.service && context.service.rust_servers.first
      end

      private

      def callin(name, command, last, cooldown)
        expires_at = last.to_i + (cooldown * 60)
        attribute  = command == 'supply.call' ? :last_supply_at : :last_heli_at

        if DateTime.now.to_i >= expires_at
          server.rcon(command, blocking: false)
          server.update_attributes(attribute => DateTime.now)
          "Calling in the #{name}!"
        else
          remaining = expires_at - DateTime.now.to_i
          minutes   = remaining / 60
          seconds   = remaining % 60

          "Cooldown active. Please wait #{minutes} minutes, #{seconds} seconds."
        end
      end

      def help
        text = 'Available Rust commands: '
        text << "'!rust' shows the current server status. "
        text << "'!rust supply' calls in a supply drop (#{SUPPLY_COOLDOWN} min cooldown)."
        text << "'!rust heli' calls in an attack helicopter (#{HELI_COOLDOWN} min cooldown)."
      end
    end
  end
end
