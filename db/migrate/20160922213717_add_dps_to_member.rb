class AddDpsToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :dps, :integer
  end
end
