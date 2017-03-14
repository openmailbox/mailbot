class CreateChannelsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.string 'name'
      t.integer 'owner_id'
    end
  end
end
