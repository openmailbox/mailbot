class AddEnabledToNewsFeedSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :news_feed_subscriptions, :enabled, :boolean, default: true
  end
end
