# Probably call this Providerable, and pass the provider name into these methods to make them generic

module Keeperable
  extend ActiveSupport::Concern

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
end
