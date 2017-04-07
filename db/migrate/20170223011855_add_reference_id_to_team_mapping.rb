class AddReferenceIdToTeamMapping < ActiveRecord::Migration[5.0]
  def change
    change_table :team_mappings do |t|
      t.rename :truevalue, :longname
      t.string :shortname
      t.integer :reference
    end
  end
end
