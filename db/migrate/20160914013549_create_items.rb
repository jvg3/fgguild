class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :slot
      t.integer :member_id
      t.integer :ilvl
      t.timestamps null: false
    end
  end
end