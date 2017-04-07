class AddLeagueReferenceToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :league_reference, :integer
  end
end
