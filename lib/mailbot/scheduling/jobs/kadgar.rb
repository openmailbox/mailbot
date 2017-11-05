module Mailbot
  module Scheduling
    class Kadgar < Job
      DISCORD_CHANNEL_ID = '342737052703391765'
      TWITCH_CHANNELS    = {'133652118' => 'open_mailbox',
                            '122233584' => 'spazee_mcgee',
                            '83111366'  => 'jeeeeeeeef',
                            '61328956'  => 'harl3m_struggl3',
                            '79397878'  => 'generalandrews1_0',
                            '68442684'  => 'flibbityflam',
                            '118029540' => 'job_for_a_cody',
                            '69300188'  => 'thebossguy11',
                            '141540943' => 'theatakapa'}

      def perform
        query   = {'channel' => TWITCH_CHANNELS.keys.join(',')}
        headers = {
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
          @message = Mailbot.instance.discord.bot.send_message(DISCORD_CHANNEL_ID, new_message)
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
