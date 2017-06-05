class CreateTaobaoItems < ActiveRecord::Migration[5.1]
  def change
    create_table :taobao_items do |t|
      t.string :item_id
      t.string :cover
      t.string :title
      t.string :description
      t.jsonb :json

      t.timestamps
    end
  end
end
