class CreateRustServers < ActiveRecord::Migration[5.0]
  def change
    create_table :rust_servers do |t|
      t.string :ip
      t.integer :port
      t.integer :rcon_port
      t.string :rcon_password
    end
  end
end
