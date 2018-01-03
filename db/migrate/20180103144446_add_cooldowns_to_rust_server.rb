class AddCooldownsToRustServer < ActiveRecord::Migration[5.0]
  def change
    add_column :rust_servers, :last_supply_at, :datetime
    add_column :rust_servers, :last_heli_at, :datetime
  end
end
