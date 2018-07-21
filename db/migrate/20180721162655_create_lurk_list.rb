class CreateLurkList < ActiveRecord::Migration[5.0]
  def change
    create_table :lurk_lists do |t|
      t.string  :nickname
      t.string  :discord_channel_id
      t.string  :guild_id
      t.text    :twitch_names
      t.integer :mailbot_rails_id
    end

    add_index :lurk_lists, :mailbot_rails_id, unique: true
  end
end
