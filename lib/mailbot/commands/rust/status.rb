module Mailbot
  module Commands
    class Rust
      class Status
        attr_reader :max_players, :players, :response, :rust

        def initialize(rust)
          @rust = rust
        end

        def execute
          @response    = rust.server.rcon('serverinfo')
          status       = response && JSON.parse(response['Message'])
          @players     = status['Players']
          @max_players = status['MaxPlayers']

          return 'Error retrieving Rust server info.' unless status

          formatted(status)
        end

        private

        def formatted(hash)
          days  = hash['Uptime'] / (3600 * 24)
          hours = (hash['Uptime'] % (3600 * 24)) / 3600

          string  = "Rust server '#{hash['Hostname']}' has been online for #{days} days, #{hours} hours. "
          string << "Current map: #{hash['Map']}. "
          string << "#{players} of #{max_players} players are connected. "
          string << "The in-game date and time is #{hash['GameTime']}. "
          string
        end
      end
    end
  end
end
