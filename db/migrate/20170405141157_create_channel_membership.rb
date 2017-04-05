class CreateChannelMembership < ActiveRecord::Migration[5.0]
  def change
    create_table :channel_memberships do |t|
      t.integer 'channel_id'
      t.integer 'user_id'
      t.float 'points'
      t.datetime 'last_message_at'
    end
  end
end
