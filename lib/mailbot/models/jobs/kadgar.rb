module Mailbot
  module Models
    # Maintain a kadgar.net link in Discord with a list of pre-configured streamer names. Automatically
    # keeps the link up to date so it only contains people who are live.
    class Kadgar < Job
      def perform
        streams_data = api.streams(details['twitch_users'])
        user_ids     = streams_data['data'].map { |i| i['user_id'] }
        users_data   = api.users(user_ids: user_ids)
        names        = users_data['data']&.map { |i| i['display_name'] }
        new_message  = kadgar_url(names)

        if message && message.content != new_message
          message.delete
          @message = discord.send_message(details['discord_channel_id'], new_message)
          self.details['discord_message_id'] = @message.id.to_s
        end

        self.last_run_at = Time.now.utc

        save!
      end

      private

      def api
        @api ||= Mailbot::Twitch::WebClient.new
      end

      def channel
        @channel ||= discord.channel(details['discord_channel_id'])
      end

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      def kadgar_url(names = [])
        'http://kadgar.net/live/' + names.join('/')
      end

      def message
        message_id = details['discord_message_id']

        return unless message_id

        @message ||= channel&.load_message(message_id)
      end
    end
  end
end
