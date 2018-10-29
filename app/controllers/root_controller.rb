class RootController < ApplicationController
  include Mumukit::Login::AuthenticationHelpers

  before_action :redirect_to_main_organization!, if: :should_redirect_to_main_organization?

  helper_method :current_user,
                :current_user?

  def should_redirect_to_main_organization?
    should_choose_organization? && current_user.has_immersive_main_organization?
  end

  def redirect_to_main_organization!
    redirect_to current_user.main_organization.url_for(request.path)
  end

  def should_choose_organization?
    current_user? && current_user.has_accessible_organizations?
  end

  def index
    @user_organizations = current_user&.accessible_organizations.to_a
    @public_organizations = Organization.select(&:public?)
  end

  def set_current_organization!
    Organization.base.switch!
  end
end
