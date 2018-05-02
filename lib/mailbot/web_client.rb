module Mailbot
  class WebClient
    URL_ROOT = 'http://bot.open-mailbox.com'.freeze

    def news_feed_subscriptions
      request('/news_feed_subscriptions.json')
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
