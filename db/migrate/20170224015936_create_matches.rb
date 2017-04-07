class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :league, foreign_key: true
      t.integer :old_reference
      t.string :season
      t.integer :round
      t.datetime :date
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :home_goals
      t.integer :away_goals
      t.integer :home_goals_halftime
      t.integer :away_goals_halftime
      t.string :status

      t.timestamps
    end
  end
end
