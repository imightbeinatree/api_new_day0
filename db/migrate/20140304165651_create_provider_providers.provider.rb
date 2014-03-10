# This migration comes from provider (originally 20131018181533)
class CreateProviderProviders < ActiveRecord::Migration
  def change
    create_table :provider_providers do |t|
      t.string   "name"
      t.string   "display_name"
	  t.string   "site"
	  t.string   "token_url"
	  t.string   "request_token_url"
	  t.string   "authorize_url"
      t.string   "check_valid_url"
      t.string   "header_format"
      t.integer  "oauth_version"
      t.timestamps
    end
    add_index "provider_providers", ["name"], :name => "index_provider_providers_on_name", :length => {"name"=>5}
  end
end
