class CreateMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :members do |t|
      t.string :name
      t.integer :class_id
      t.string :role
      t.integer :ilvl
      t.timestamps null: false
    end
  end
end