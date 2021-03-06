class Devise::AjaxSessionsController < DeviseController
  doorkeeper_for :all, except: [:new, :create, :failure]
  respond_to :json
  prepend_before_filter :require_no_authentication, only: [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, only: :create
  prepend_before_filter only: [ :create, :destroy ] { request.env["devise.skip_timeout"] = true }

  def manage_doorkeeper_token(resource, application_id)
      # Create an OAuth2 Access token to be rendered
      token = Doorkeeper::AccessToken.where(
        application_id: application_id,
        resource_owner_id: resource.id,
        revoked_at: nil
      ).order(:created_at).last

      if !token || token.expired?
        token = Doorkeeper::AccessToken.create!(
          application_id: 1,
          resource_owner_id: resource.id
        )
      end

      token
  end


  def get_token(resource, application_id)
    Doorkeeper::AccessToken.where(application_id: application_id,resource_owner_id: resource.id,revoked_at: nil).order(:created_at).last.token
  end

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "devise/ajax_sessions#failure")
    return sign_in_and_redirect(resource_name, resource)
  end
  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    token = manage_doorkeeper_token(resource, 1)
    return render :json => {:success => true, :redirect => stored_location_for(scope) ||     
    after_sign_in_path_for(resource)}.merge("token" => get_token(resource, 1), :status=>201)
  end
 
  def failure
    return render:json => {:success => false, :errors => ["Login failed."]}
  end

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield resource if block_given?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end
end