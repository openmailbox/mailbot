module Mailbot
  module Scheduling
    class Kadgar < Job
      def perform
        channels = Mailbot.configuration.discord.kadgar['twitch_ids']
        discord  = Mailbot.configuration.discord.kadgar['discord_channel']
        query    = {'channel' => channels.join(',')}
        headers  = {
          'Client-ID' => Mailbot.configuration.twitch.client_id,
          'Accept'    => 'application/vnd.twitchtv.v5+json'
        }

        response = HTTParty.get('https://api.twitch.tv/kraken/streams',
                                headers: headers,
                                query:   query)

        names       = response['streams'].map { |i| i['channel']['name'] }
        new_message = kadgar_url(names)

        if @message
          @message.edit(new_message)
        else
          @message = Mailbot.instance.discord.bot.send_message(discord, new_message)
        end

        @last_run = Time.now.to_i
      end

      private

      def kadgar_url(names)
        "http://kadgar.net/live/" + names.join('/')
      end
    end
  end
end
