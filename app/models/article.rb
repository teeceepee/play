class Article < ApplicationRecord
  include Elasticsearch::Model if defined?(Elasticsearch)

  # elasticsearch-plugin install analysis-smartcn
  mapping do
    # indexes :id, type: 'long'

    indexes :title, type: 'text' do
      indexes :chinese, type: 'text', analyzer: 'smartcn'
      indexes :keyword, type: 'text'
    end
    indexes :content, type: 'text' do
      indexes :chinese, type: 'text', analyzer: 'smartcn'
      indexes :keyword, type: 'text'
    end

    indexes :created_at, type: 'date'
    indexes :updated_at, type: 'date'
  end if self.respond_to?(:mapping)

end
