class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :require_login
  if ENV.has_key? 'DMEMO_ALLOW_ANONYMOUS_TO_READ'
    skip_before_action :require_login, only: [:index, :show]
  end
  before_action :set_sidebar_databases, :set_search_result, only: %w(index show new edit)

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    return if current_user
    redirect_to google_oauth2_path(state: url_for(params.merge(only_path: true)))
  end

  def require_admin_login
    redirect_to root_path unless current_user.admin?
  end

  def set_sidebar_databases
    @sidebar_databases = DatabaseMemo.all.select(:name).order(:name)
  end

  def set_search_result
    @search_result = SearchResult.new
  end
end
