class HupuNews < ApplicationRecord

  store_accessor :json, [:news_id, :href, :title, :img_url]

end
