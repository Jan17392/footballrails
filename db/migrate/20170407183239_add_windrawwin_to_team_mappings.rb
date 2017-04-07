class AddWindrawwinToTeamMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :team_mappings, :windrawwin, :string
  end
end
