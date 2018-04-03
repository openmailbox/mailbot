class CreateRssItem < ActiveRecord::Migration[5.0]
  def change
    create_table :rss_items do |t|
      t.string :guid
      t.string :title
      t.datetime :published_at
      t.string :link
      t.string :description
      t.integer :news_feed_id
    end

    add_index :rss_items, :guid
    add_index :rss_items, :news_feed_id
  end
end
