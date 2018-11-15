class AddActiveToNewsFeedSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :news_feed_subscriptions, :active, :boolean, default: true
  end
end
