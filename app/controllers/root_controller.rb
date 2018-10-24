class RootController < ApplicationController
  include Mumukit::Login::AuthenticationHelpers

  before_action :redirect_to_main_organization!, if: :should_redirect_to_main_organization?

  helper_method :current_user,
                :current_user?

  def index
    @user_organizations = current_user&.accessible_organizations.to_a
    @public_organizations = Organization.select(&:public?)
  end

  def set_current_organization!
    Organization.base.switch!
  end
end
