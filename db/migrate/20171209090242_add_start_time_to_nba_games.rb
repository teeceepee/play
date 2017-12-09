class AddStartTimeToNbaGames < ActiveRecord::Migration[5.1]
  def change
    add_column :nba_games, :start_time, :datetime
  end
end
