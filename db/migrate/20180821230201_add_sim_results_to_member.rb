class AddSimResultsToMember < ActiveRecord::Migration
  def change
    add_column :members, :sim_results, :text
  end
end
