class RenameTaobaoItems < ActiveRecord::Migration[5.1]
  def change
    rename_column :taobao_items, :item_id, :item_no
  end
end
