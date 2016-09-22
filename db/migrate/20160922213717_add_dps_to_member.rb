class AddDpsToMember < ActiveRecord::Migration
  def change
    add_column :members, :dps, :integer
  end
end
