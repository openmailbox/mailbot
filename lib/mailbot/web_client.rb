module Mailbot
  class WebClient
    URL_ROOT = 'http://bot.open-mailbox.com'.freeze

    # @param [DateTime] timestamp The lookback period
    def news_feed_subscriptions(timestamp = 0)
      request("/news_feed_subscriptions.json?since=#{timestamp.to_i}")
    end

    private

    def headers
      {
        "X-MAILBOT-API-TOKEN" => Mailbot.configuration.api_token
      }
    end

    def request(path)
      response = HTTParty.get(URL_ROOT + path, headers: headers)

      if response.success?
        JSON.parse(response.body)
      else
        Rails.logger.warn("API request to #{path} failed: #{response.inspect}")
        nil
      end
    rescue
      nil
    end
  end
end
