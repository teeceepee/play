class CreateNbaImages < ActiveRecord::Migration[5.1]
  def change
    create_table :nba_images do |t|
      t.references :topic, foreign_key: true
      t.string :url
      t.text :content
      t.references :nba_game, foreign_key: true

      t.timestamps
    end
  end
end
