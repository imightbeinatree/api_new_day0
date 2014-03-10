Doorkeeper.configure do
  default_scopes :default

  authorization_code_expires_in 30.days

  resource_owner_authenticator do
    current_user || warden.authenticate!(:scope => :user)
  end

  resource_owner_from_credentials do |routes|
    request.params[:user] = {:email => request.params[:username], :password => request.params[:password]}

    request.env["devise.allow_params_authentication"] = true
    resource = request.env["warden"].authenticate!(:scope => :user, :store => false)
  end
end