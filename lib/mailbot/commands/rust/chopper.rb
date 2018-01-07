module Mailbot
  module Commands
    class Rust
      class Chopper
        COOLDOWN = 30 # minutes

        attr_reader :response, :rust

        def initialize(rust)
          @rust = rust
        end

        def execute
          expires_at = rust.server.last_heli_at.to_i + (COOLDOWN * 60)

          if DateTime.now.to_i >= expires_at
            @response   = rust.server.rcon('chopper random')
            coordinates = response['Message'].match(/\(.+\)/)[0]

            rust.server.update_attributes(last_heli_at: DateTime.now)

            "#{rust.user.name} has called in an attack helicopter at #{coordinates}."
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