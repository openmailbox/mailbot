class CreateLurkList < ActiveRecord::Migration[5.0]
  def change
    create_table :lurk_lists do |t|
      t.string :nickname
      t.string :discord_channel_id
      t.string :guild_id
      t.text   :twitch_names
    end
  end
end
