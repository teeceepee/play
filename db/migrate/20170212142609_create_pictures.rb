class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.string :filename
      t.string :pid

      t.timestamps
    end
  end
end
