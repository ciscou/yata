class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  private

  # shamelessly stolen from https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  def authenticate_user_from_token!
    user_email = request.headers['HTTP_USER_EMAIL'].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, request.headers['HTTP_USER_TOKEN'])
      sign_in user, store: false
    end
  end
end
