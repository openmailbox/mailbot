class AddMessageIdToLurkList < ActiveRecord::Migration[5.0]
  def change
    add_column :lurk_lists, :discord_message_id, :string
  end
end
