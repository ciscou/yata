class AuthenticationTokensController < ApplicationController
  before_filter :authenticate_user!, except: :create

  def create
    user = User.find_for_database_authentication email: params[:user][:email]
    if user && user.valid_password?(params[:user][:password])
      user.ensure_authentication_token!
      render json: { success: true, auth_token: user.authentication_token }
    else
      render json: { success: false, message: t("devise.failure.invalid") }, status: :unauthorized
    end
  end
end
