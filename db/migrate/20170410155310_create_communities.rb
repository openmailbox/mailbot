class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.string 'name'
      t.integer 'platform_id'
      t.integer 'user_id'
      t.datetime 'created_at'
    end
  end
end
