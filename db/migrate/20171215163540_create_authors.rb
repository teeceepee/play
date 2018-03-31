class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :bio
      t.string :homepage
      t.string :twitter
      t.string :facebook

      t.timestamps
    end
  end
end
