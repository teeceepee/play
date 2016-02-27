class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references :repo, index: true, foreign_key: true
      t.string :name
      t.string :git_url
      t.string :git_commit
      t.string :dockerfile_dir

      t.timestamps
    end
  end
end
