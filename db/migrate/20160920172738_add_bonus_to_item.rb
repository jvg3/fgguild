class AddBonusToItem < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :item_id, :integer
    add_column :items, :bonus, :integer
  end
end
