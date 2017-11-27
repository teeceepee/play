class AddStatusToArticles < ActiveRecord::Migration[5.1]
  class Article < ActiveRecord::Base; end

  def change
    add_column :articles, :status, :string
    add_column :articles, :published_at, :datetime

    Article.find_each do |article|
      article.update_column(:status, :published)
    end
  end
end
