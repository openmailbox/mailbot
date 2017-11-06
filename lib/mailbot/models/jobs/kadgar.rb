module Mailbot
  module Models
    class Kadgar < Job
      serialize :details, JSON

      def perform
        query   = {'channel' => details['twitch_ids'].join(',')}
        headers = {
          'Client-ID' => Mailbot.configuration.twitch.client_id,
          'Accept'    => 'application/vnd.twitchtv.v5+json'
        }

        response = HTTParty.get('https://api.twitch.tv/kraken/streams',
                                headers: headers,
                                query:   query)

        names       = response['streams'].map { |i| i['channel']['name'] }
        new_message = kadgar_url(names)

        if message
          message.edit(new_message)
        else
          discord.send_message(details['discord_channel_id'], new_message)
        end

        self.last_run_at = Time.now.utc
        save!
      end

      private

      def channel
        return @channel if @channel

        server_id = details['server_id']

        if server_id
          server   = discord.servers[server_id]
          @channel = server.text_channels.find { |i| i.id == details['discord_channel_id'] }
        else
          # TODO: Get the user DM channel
        end
      end

      def discord
        @discord ||= Mailbot.instance.discord.bot
      end

      def kadgar_url(names)
        "http://kadgar.net/live/" + names.join('/')
      end

      def message
        message_id = details['discord_message_id']

        return unless message_id

        @message ||= channel&.load_message(message_id)
      end
    end
  end
end
