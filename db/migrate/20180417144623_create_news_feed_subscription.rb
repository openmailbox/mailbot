class CreateNewsFeedSubscription < ActiveRecord::Migration[5.0]
  def change
    create_table :news_feed_subscriptions do |t|
      t.integer :news_feed_id
      t.string :discord_channel_id
    end

    add_index :news_feed_subscriptions, :news_feed_id
  end
end
