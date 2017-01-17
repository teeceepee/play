# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include UserAuth

    identified_by :current_u

    def connect
      self.current_u = find_verified_user
    end

    protected
    def find_verified_user
      if current_user.present?
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
