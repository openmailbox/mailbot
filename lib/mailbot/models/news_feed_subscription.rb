# == Schema Information
#
# Table name: news_feed_subscriptions
#
#  id                 :integer          not null, primary key
#  news_feed_id       :integer
#  discord_channel_id :string
#  guild_id           :string
#
# Indexes
#
#  index_news_feed_subscriptions_on_guild_id      (guild_id)
#  index_news_feed_subscriptions_on_news_feed_id  (news_feed_id)
#

module Mailbot
  module Models
    class NewsFeedSubscription < ActiveRecord::Base
      belongs_to :news_feed

      validates :discord_channel_id, presence: true

      # @param [Mailbot::Models::RssItem] item The item to send to Discord
      def notify_discord(item)
        discord.send_message(discord_channel_id, item.to_s, false, item.to_discord_embed)
      rescue RestClient::NotFound, Discordrb::Errors::NoPermission => e
        Mailbot.logger.warn("Unable to send Discord message to channel 
                            #{discord_channel_id} due to #{e.message}. Skipping.")

        context = {
          channel: discord_channel_id,
          message: item.to_s,
          guild:   guild_id
        }

        Raven.capture_exception(e, extra: context)
      end

      private

      def discord
        @discord ||= Mailbot.instance.discord
      end
    end
  end
end
