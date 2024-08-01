class SessionsController < ApplicationController
  before_action :find_by_email, only: :create

  def create
    if @user.authenticate params.dig(:session, :password)
      if @user.activated?
        handle_successful_login @user
      else
        flash[:warning] = t ".message.not_activated"
        redirect_to root_url, status: :see_other
      end
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def find_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t ".message.no_user"
    render :new, status: :unprocessable_entity
  end

  def handle_successful_login user
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
    redirect_to forwarding_url || user
  end

  def handle_failed_login
    flash.now[:danger] = t ".message.invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end
