class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user

  def login_user(user_params)
    user = User.find_by_params(user_params)
    return nil if user.nil?
    session[:token] = user.create_session
  end

  def current_user
    user = Session.find_by(token: session[:token])
    user.nil? ? nil : user.user
  end

  def logged_in?
    !current_user.nil?
  end

  def inform(info)
    flash[:info] ||= []
    flash[:info] << info
  end

  def redirect_if_logged_in
    redirect_to root_url if logged_in?
  end

  def redirect_unless_logged_in
    redirect_to root_url unless logged_in?
  end
end
