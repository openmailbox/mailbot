class CreateDiscordIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :discord_identities do |t|
      t.string :uid, index: true
      t.string :name
      t.string :email
      t.string :image_url
      t.string :token
      t.string :refresh_token
      t.datetime :expires_at
      t.boolean :expires
      t.string :username
      t.string :discriminator
      t.boolean :mfa_enabled
      t.string :extra_id
      t.string :avatar
      t.references :user, foreign_key: true
      t.boolean :bot, default: false

      t.timestamps
    end
  end
end
