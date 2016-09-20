class AddEnchantToItem < ActiveRecord::Migration
  def change
    add_column :items, :enchant, :integer
    add_column :items, :gem0, :integer
    add_column :items, :gem1, :integer
    add_column :items, :gem2, :integer
  end
end
