class CreateOdds < ActiveRecord::Migration[5.0]
  def change
    create_table :odds do |t|
      t.string :provider
      t.decimal :home_odd
      t.decimal :draw_odd
      t.decimal :away_odd
      t.references :match, foreign_key: true

      t.timestamps
    end
  end
end
