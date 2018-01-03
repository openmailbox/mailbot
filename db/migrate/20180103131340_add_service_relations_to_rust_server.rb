class AddServiceRelationsToRustServer < ActiveRecord::Migration[5.0]
  def change
    add_column :rust_servers, :community_id, :integer, index: true
    add_column :rust_servers, :channel_id, :integer, index: true
  end
end
