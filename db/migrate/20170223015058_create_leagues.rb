class CreateLeagues < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.integer :country_id
      t.string :leaguename

      t.timestamps
    end
  end
end
