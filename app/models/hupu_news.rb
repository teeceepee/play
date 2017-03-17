class HupuNews < ApplicationRecord
  include Elasticsearch::Model if defined?(Elasticsearch)

  store_accessor :json, [:news_id, :href, :title, :img_url]

  def self.search_by_query(query)
    if query.present? && self.respond_to?(:search)
      self.search(query).records
    else
      self.order(id: :desc)
    end
  end

  def as_indexed_json(options = {})
    {
      title: self.title
    }
  end
end
