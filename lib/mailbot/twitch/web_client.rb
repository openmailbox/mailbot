module Mailbot
  module Twitch
    class WebClient
      URL_ROOT = 'https://api.twitch.tv/helix'.freeze

      def streams(user_names = [])
        params = user_names.map { |i| "user_login=#{i}" }
        request("/streams?#{params.join('&')}") || {}
      end

      def users(user_names: [], user_ids: [])
        params = user_names.any? && user_names.map { |i| "login=#{i}" }
        params ||= user_ids.any? && user_ids.map { |i| "id=#{i}" }

        (params && request("/users?#{params.join('&')}")) || {}
      end

      private

      def headers
        {
          "Client-ID" => Mailbot.configuration.twitch.client_id
        }
      end

      def request(path)
        response = HTTParty.get(URL_ROOT + path, headers: headers)

        if response.success?
          JSON.parse(response.body)
        else
          Mailbot.logger.warn("API request to #{path} failed: #{response.inspect}")
          nil
        end
      rescue => e
        Mailbot.logger.warn("Error while making API request to #{path}: #{e.message}")
        Mailbot.logger.warn(e.backtrace)
        nil
      end
    end
  end
end
