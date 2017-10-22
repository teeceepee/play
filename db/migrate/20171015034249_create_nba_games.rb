class CreateNbaGames < ActiveRecord::Migration[5.1]
  def change
    create_table :nba_games do |t|
      t.string :season_year
      t.string :season_type
      t.date :date
      t.string :road
      t.string :home
      t.integer :road_score
      t.integer :home_score

      t.timestamps
    end
  end
end
