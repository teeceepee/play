module UserAuth
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :sign_in, :sign_out

    def auth_user
      if current_user.nil?
        store_location
        redirect_to login_path
      end
    end

    def current_user
      user_id, user_auth_token = cookies.signed[User::REMEMBER_TOKEN_KEY]
      user = User.find_by(id: user_id, auth_token: user_auth_token)
      @current_user ||= user
    end


    # @param user [User]
    # @param remember_me [Boolean]
    def sign_in(user, remember_me: false)
      options = {
        value: [user.id, user.auth_token],
        httponly: true,
      }
      if remember_me
        options[:expires] = User::REMEMBER_ME_DURATION.from_now
      end

      cookies.signed[User::REMEMBER_TOKEN_KEY] = options
    end

    def sign_out
      cookies.delete(User::REMEMBER_TOKEN_KEY)
    end

    def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
      session.delete(:return_to)
    end

    def store_location
      session[:return_to] = request.fullpath if request.get?
    end

  end
end
