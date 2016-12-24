class CreateHupuNews < ActiveRecord::Migration[5.0]
  def change
    create_table :hupu_news do |t|
      t.json :json
      t.json :box

      t.timestamps
    end
  end
end
