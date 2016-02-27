class AddDockerfileContentToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :dockerfile_content, :text
    add_column :tags, :dockerfile_downloaded_at, :datetime
  end
end
