class AddPropredictionToTeamMappings < ActiveRecord::Migration[5.0]
  def change
    change_table :team_mappings do |t|
      t.string :proprediction
    end
  end
end
