class AsgardController < ApplicationController
  layout 'buyer'
  before_action :auth_user

end
