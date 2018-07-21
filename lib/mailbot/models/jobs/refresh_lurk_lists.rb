module Mailbot
  module Models
    class RefreshLurkLists < Job
      def perform
        last = last_run_at.to_i
        self.last_run_at = DateTime.now.utc

        api.lurk_lists(last).each do |data|
          list = LurkList.find_or_initialize_by(mailbot_rails_id: data['id'])

          list.nickname           = data['nickname']
          list.twitch_names       = data['twitch_names']
          list.discord_channel_id = data['discord_channel_id']
          list.guild_id           = data['guild_id']

          list.save! if list.changed?
        end

        save!
      end

      private

      def api
        @api ||= Mailbot::WebClient.new
      end
    end
  end
end
