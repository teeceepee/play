module UserAuth
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :sign_in, :sign_out

    def auth_user
      if current_user.nil?
        redirect_to login_path
      end
    end

    def current_user
      user_id, user_auth_token = cookies.signed[User::REMEMBER_TOKEN_KEY]
      user = User.find_by(id: user_id, auth_token: user_auth_token)
      @current_user ||= user
    end


    # @param [User] user
    def sign_in(user)
      cookies.signed[User::REMEMBER_TOKEN_KEY] = [user.id, user.auth_token]
    end

    def sign_out
      cookies.delete(User::REMEMBER_TOKEN_KEY)
    end

  end
end
