class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.jsonb :json
      t.jsonb :box

      t.timestamps
    end
  end
end
