# This migration comes from provider (originally 20131018181907)
class CreateProviderAuthentications < ActiveRecord::Migration
  def change
    create_table :provider_authentications do |t|
      t.integer :authenticatable_id
      t.string :authenticatable_type
      t.integer :provider_id
      t.string   "token"
      t.string   "secret"
      t.string   "uid"
      t.string   "refresh_token"
      t.datetime "expires_at"
      t.timestamps
    end

    add_index "provider_authentications", ["provider_id"], :name => "index_provider_authentications_on_provider_id"
    add_index "provider_authentications", ["uid"], :name => "index_provider_authentications_on_uid", :unique => true
    add_index "provider_authentications", ["authenticatable_id"], :name => "index_provider_authentications_on_authenticatable_id"
    add_index "provider_authentications", ["authenticatable_type"], :name => "index_provider_authentications_on_authenticatable_type"
  end
end
