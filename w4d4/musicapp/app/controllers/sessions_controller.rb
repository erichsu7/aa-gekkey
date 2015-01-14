class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    if params[:submit] == "create"
      @user = User.new(user_params)
      if @user.save
        flash[:info] = ["User created"]
        login_user(user_params)
        redirect_to root_url
      else
        flash.now[:errors] = @user.errors.full_messages
        render :new
      end
    elsif params[:submit] == "log in"
      @user = login_user(user_params)
      if @user
        flash[:info] ||= []
        flash[:info] << "logged in"
        redirect_to root_url
      else
        @user = User.new(user_params)
        flash.now[:errors] = ["username or password incorrect"]
        render :new
      end
    end
  end

  def destroy
    user = current_user
    if user
      user.end_session(session[:token])
      session[:token] = nil
      redirect_to root_url
    else
      flash[:errors] = ["You tried to log out without being logged in."\
                        "This should not be possible."\
                        "The fuck you up to, mate?"]
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
