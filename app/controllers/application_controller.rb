class ApplicationController < ActionController::Base
  Mumukit::Login.configure_controller! self

  protect_from_forgery with: :exception

  include Mumuki::Laboratory::Controllers::CurrentOrganization
  include Mumukit::Login::AuthenticationHelpers

  include Mumuki::Laboratory::Controllers::Authorization
  include Mumuki::Laboratory::Controllers::Notifications
  include Mumuki::Laboratory::Controllers::DynamicErrors
  include Mumuki::Laboratory::Controllers::EmbeddedMode

  before_action :set_current_organization!
  before_action :set_locale!
  before_action :authorize_if_private!
  before_action :validate_user_profile!, if: :current_user?
  before_action :visit_organization!, if: :current_user?

  after_action :leave_organization!

  helper_method :login_button,
                :notifications_count,
                :user_notifications_path,
                :has_notifications?,
                :subject,
                :theme_stylesheet_url,
                :extension_javascript_url

  # ensures contents are accessible to current user
  def validate_accessible!
    return if current_user&.teacher_here?
    accessible_subject.validate_accessible_for! current_user
  end

  # required by Mumukit::Login
  def login_button(options={})
    login_form.button_html I18n.t(:sign_in), options[:class]
  end

  private

  def login_settings
    Organization.current.login_settings
  end

  def validate_user_profile!
    return if !current_user.has_accessible_organizations? || current_user.profile_completed?
    flash.notice = I18n.t :please_fill_profile_data
    redirect_to user_path
  end

  def set_locale!
    I18n.locale = Organization.current.locale
  end

  def subject #TODO may be used to remove breadcrumbs duplication
    nil
  end

  def leave_organization!
    Mumukit::Platform::Organization.leave!
  end
end
