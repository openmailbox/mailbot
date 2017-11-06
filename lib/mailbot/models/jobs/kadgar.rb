module Mailbot
  module Models
    class Kadgar < Job
      def perform
        query       = {'channel' => details['twitch_ids'].join(',')}
        response    = HTTParty.get(twitch_url, headers: headers, query: query)
        names       = response['streams'].map { |i| i['channel']['name'] }
        new_message = kadgar_url(names)

        if message
          message.edit(new_message)
        else
          @message = discord.send_message(details['discord_channel_id'], new_message)
          self.details['discord_message_id'] = @message.id.to_s
        end

        self.last_run_at = Time.now.utc

        save!
      end

      private

      def channel
        @channel ||= discord.channel(details['discord_channel_id'])
      end

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      def headers
        {
          'Client-ID' => Mailbot.configuration.twitch.client_id,
          'Accept'    => 'application/vnd.twitchtv.v5+json'
        }
      end

      def kadgar_url(names)
        'http://kadgar.net/live/' + names.join('/')
      end

      def message
        message_id = details['discord_message_id']

        return unless message_id

        @message ||= channel&.load_message(message_id)
      end

      def twitch_url
        Mailbot.configuration.twitch.rest_api_root + '/streams'
      end
    end
  end
end
