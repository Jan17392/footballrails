class CreateTeamMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :team_mappings do |t|
      t.string :truevalue
      t.string :zulubet
      t.string :statarea

      t.timestamps
    end
  end
end
