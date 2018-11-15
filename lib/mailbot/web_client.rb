module Mailbot
  class WebClient
    URL_ROOT = 'http://bot.open-mailbox.com'.freeze

    # @param [DateTime] timestamp The lookback period
    def lurk_lists(timestamp = 0)
      request("/lurk_lists.json?since=#{timestamp.to_i}") || []
    end

    # @param [DateTime] timestamp The lookback period
    def news_feed_subscriptions(timestamp = 0)
      request("/news_feed_subscriptions.json?since=#{timestamp.to_i}") || []
    end

    # @param [DateTime] timestamp The lookback period
    def removed_records(timestamp = 0)
      request("/removed_records.json?since=#{timestamp.to_i}") || []
    end

    # @param [Mailbot::Models::NewsFeedSubscription] subscription The subscription that is being updated
    def update_news_feed_subscription(subscription)
      HTTParty.put(URL_ROOT + "/admin/news_feed_subscriptions/#{subscription.api_id}",
                   body: subscription.attributes.to_json,
                   headers: headers,
                   timeout: 20)
    rescue => e
      Mailbot.logger.warn("Error while updating news feed subscription: #{e.message}")
      Mailbot.logger.warn(e.backtrace)
      Raven.capture_exception(e)
      nil
    end

    private

    def headers
      {
        "X-MAILBOT-API-TOKEN" => Mailbot.configuration.api_token
      }
    end

    def request(path)
      response = HTTParty.get(URL_ROOT + path, headers: headers, timeout: 20)

      if response.success?
        JSON.parse(response.body)
      else
        Mailbot.logger.warn("API request to #{path} failed: #{response.inspect}")
        nil
      end
    rescue => e
      Mailbot.logger.warn("Error while making API request to #{path}: #{e.message}")
      Mailbot.logger.warn(e.backtrace)
      Raven.capture_exception(e)
      nil
    end
  end
end
