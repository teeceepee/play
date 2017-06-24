class CreateTaobaoReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :taobao_reviews do |t|
      t.string :item_no
      t.string :review_no
      t.string :parent_no
      t.jsonb :json

      t.timestamps
    end

    add_index :taobao_items, :item_no
    add_index :taobao_reviews, :item_no
    add_index :taobao_reviews, :review_no
    add_index :taobao_reviews, :parent_no
  end
end
