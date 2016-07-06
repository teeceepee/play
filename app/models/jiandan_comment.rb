class JiandanComment < ApplicationRecord

  store_accessor :json, [:comment_id, :page]
end
