class AddImageToNbaImages < ActiveRecord::Migration[5.1]
  def change
    add_column :nba_images, :image, :string
  end
end
