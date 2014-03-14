# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

d = Doorkeeper::Application.first.blank? ? Doorkeeper::Application.new : Doorkeeper::Application.first
d.redirect_uri = "http://www.newdayzero.com"
d.name = "new_day_zero"
d.save

#
# BEGIN PROVIDERS
#
provider_attrs_array = [{
  name: "facebook",
  display_name: "facebook",
  site: "https://graph.facebook.com",
  token_url: "/oauth/access_token",
  request_token_url: "",
  authorize_url: "",
  check_valid_url: "/me",
  header_format: "OAuth %s",
  oauth_version: 2
},

{
  name:'twitter',
  display_name:'twitter',
  site:'https://api.twitter.com',
  authorize_url:'/oauth/authenticate',
  check_valid_url:'/1/account/verify_credentials.json',
  oauth_version:1
}]

provider_attrs_array.each do |provider_attrs|
	if !Provider::Provider.where("name = ?", provider_attrs[:name]).first.present?
	  p = Provider::Provider.new(provider_attrs)
	  if p.save!
	    puts "#{provider_attrs[:name]} provider created" if Rails.env != 'test'
	  else
	    puts "ERROR creating #{provider_attrs[:name]} provider" if Rails.env != 'test'
	  end
	end
end
#
# END PROVIDERS
#