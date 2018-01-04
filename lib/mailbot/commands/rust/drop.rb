module Mailbot
  module Commands
    class Rust
      class Drop
        COOLDOWN = 20 # minutes

        attr_reader :response, :rust

        def initialize(rust)
          @rust = rust
        end

        def execute
          expires_at = rust.server.last_supply_at.to_i + (COOLDOWN * 60)

          if DateTime.now.to_i >= expires_at
            @response   = rust.server.rcon('airdrop random')
            coordinates = response['Message'].match(/\(.+\)/)[0]

            rust.server.update_attributes(last_supply_at: DateTime.now)

            "#{rust.user.name} has called in an air drop at #{coordinates}."
          else
            remaining = expires_at - DateTime.now.to_i
            minutes   = remaining / 60
            seconds   = remaining % 60

            "Cooldown active. Please wait #{minutes} minutes, #{seconds} seconds."
          end
        end
      end
    end
  end
end
