class AddMoreProvidersToTeamMappings < ActiveRecord::Migration[5.0]
  def change
    change_table :team_mappings do |t|
      t.string :bettingclosed
      t.string :hintwise
      t.string :iqbet
      t.string :prosoccereu
      t.string :prosoccergr
    end
  end
end
