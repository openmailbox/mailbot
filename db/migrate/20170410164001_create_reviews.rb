class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer 'rating'
      t.integer 'user_id'
      t.integer 'game_id'
      t.datetime 'created_at'
    end
  end
end
