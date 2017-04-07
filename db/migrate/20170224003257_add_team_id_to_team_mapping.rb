class AddTeamIdToTeamMapping < ActiveRecord::Migration[5.0]
  def change
    add_column :team_mappings, :team_id, :integer
  end
end
