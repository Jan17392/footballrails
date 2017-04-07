class AddBetexplorerToTeamMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :team_mappings, :betexplorer, :string
  end
end
