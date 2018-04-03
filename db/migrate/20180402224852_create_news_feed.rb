class CreateNewsFeed < ActiveRecord::Migration[5.0]
  def change
    create_table :news_feeds do |t|
      t.string :title
      t.string :link
      t.string :decription
      t.string :reader_class
      t.datetime :last_build_at
    end

    add_index :news_feeds, :link
  end
end
