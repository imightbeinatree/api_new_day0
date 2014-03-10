class Devise::AjaxRegistrationsController < DeviseController
  doorkeeper_for :all, except: [:new, :create, :json_new, :cancel]
  respond_to :json
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]


  # GET /resource/sign_up
  def new
    build_resource({})
    respond_with self.resource
  end
  
  # GET /resource/sign_up
  def json_new
    build_resource({})
    respond_with self.resource
  end
  
  # POST /resource
  def create
    build_resource(sign_up_params)
Rails.logger.info "resource built #{resource.inspect}"
    if resource.save

      # Create an OAuth2 Access token to be rendered
      token = Doorkeeper::AccessToken.where(
        application_id: 1,
        resource_owner_id: resource.id,
        revoked_at: nil
      ).order(:created_at).last

      if !token || token.expired?
        Doorkeeper::AccessToken.create!(
          application_id: 1,
          resource_owner_id: resource.id
        )
      end

      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        render :json=> resource.as_json().merge("token" => Doorkeeper::AccessToken.where(application_id: 1,resource_owner_id: resource.id,revoked_at: nil).order(:created_at).last.token), :status=>201
      else
        expire_data_after_sign_in!
        render :json=> resource.as_json(), :status=>202
      end
    else
      clean_up_passwords resource
      render :json=> resource.errors, :status=>422
    end
  end
  
  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end
  
 protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  def sign_up_params
    {email: params[:ajax_registration][:email], password: params[:ajax_registration][:password], password_confirmation: params[:ajax_registration][:password_confirmation]}
  end
end