class AddBonusToItem < ActiveRecord::Migration
  def change
    add_column :items, :item_id, :integer
    add_column :items, :bonus, :integer
  end
end
