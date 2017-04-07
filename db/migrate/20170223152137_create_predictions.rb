class CreatePredictions < ActiveRecord::Migration[5.0]
  def change
    create_table :predictions do |t|
      t.integer :match_id
      t.references :expert
      t.decimal :home_probability
      t.decimal :draw_probability
      t.decimal :away_probability
      t.integer :home_goals_predicted
      t.integer :away_goals_predicted
      t.string :winner_predicted
      t.decimal :home_probability_halftime
      t.decimal :draw_probability_halftime
      t.decimal :away_probability_halftime
      t.decimal :over_15_goals_probability
      t.decimal :over_25_goals_probability
      t.decimal :over_35_goals_probability

      t.timestamps
    end
  end
end
