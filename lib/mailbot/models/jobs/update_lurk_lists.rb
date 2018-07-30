module Mailbot
  module Models
    class UpdateLurkLists < Job
      API_LIMIT = 100

      def perform
        self.last_run_at = DateTime.now.utc

        @stream_cache = []

        build_stream_cache
        notify_changes

        save!
      end

      private

      def api
        @api ||= Mailbot::Twitch::WebClient.new
      end

      def build_stream_cache
        pending_names = []
        done_names    = []

        Mailbot::Models::LurkList.find_each do |list|
          if (pending_names.length + list.twitch_names.length) > API_LIMIT
            fetch_streams(pending_names)
            done_names |= pending_names
            pending_names = []
          end

          list.twitch_names.each do |name|
            pending_names << name if !pending_names.include?(name) && !done_names.include?(name)
          end
        end

        fetch_streams(pending_names)

        @stream_cache.each_slice(100) do |slice|
          ids = slice.map { |i| i['user_id'] }

          api.users(user_ids: ids).fetch('data', []).each do |json|
            @stream_cache.find { |i| i['user_id'] == json['id'] }&.merge!('display_name' => json['display_name'])
          end
        end
      end

      def channel(list)
        discord.channel(list.discord_channel_id)
      end

      def fetch_streams(names)
        @stream_cache += api.streams(names).fetch('data', [])
      end

      def notify_changes
        LurkList.find_each do |list|
          streams     = @stream_cache.select { |i| list.twitch_names.map(&:downcase).include?(i['display_name'].downcase) }
          new_message = message_for(streams.map  { |i| i['display_name'] })
          existing    = old_message(list)

          if existing&.content != new_message
            existing.delete if existing

            message = discord.send_message(list.discord_channel_id, new_message)
            list.discord_message_id = message.id.to_s

            list.save! if list.changed?
          end
        end
      end

      def old_message(list)
        channel(list)&.load_message(list.discord_message_id)
      end

      def message_for(names)
        'http://kadgar.net/live/' + names.to_a.join('/')
      end
    end
  end
end
