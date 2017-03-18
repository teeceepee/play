class Article < ApplicationRecord
  include Elasticsearch::Model if defined?(Elasticsearch)


end
