class AddSimResultsToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :sim_results, :text
  end
end
