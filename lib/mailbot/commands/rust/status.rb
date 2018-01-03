module Mailbot
  module Commands
    class Rust
      class Status
        attr_reader :response, :rust

        def initialize(rust)
          @rust = rust
        end

        def execute
          @response = rust.server.rcon('status')
          status    = parse_response

          return 'Error retrieving Rust server info.' unless status

          formatted(status)
        end

        private

        def formatted(hash)
          current, max = hash['players'].match(/(\d+) \((\d+)/)[1,2]

          string  = "Rust server '#{hash['hostname']}' is up! "
          string << "Current map: #{hash['map']}. "
          string << "#{current} of #{max} players are connected."
          string
        end

        # @return [Hash] Key-value pairs for the server status
        def parse_response
          return unless response
          
          tokens = response['Message'].split("\n\n").first.split("\n").map { |i| i.split(':') }.map { |i| i.map(&:strip) }

          Hash[tokens]
        end
      end
    end
  end
end
