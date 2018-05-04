class AddGuildIdToNewsFeedSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :news_feed_subscriptions, :guild_id, :string

    add_index :news_feed_subscriptions, :guild_id
  end
end
