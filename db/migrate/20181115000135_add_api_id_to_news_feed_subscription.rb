class AddApiIdToNewsFeedSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :news_feed_subscriptions, :api_id, :bigint
  end
end
