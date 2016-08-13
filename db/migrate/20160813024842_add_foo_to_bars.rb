class AddFooToBars < ActiveRecord::Migration[5.0]
  def change
    add_column :bars, :foo, :string
    add_column :bars, :baz, :text
  end
end
