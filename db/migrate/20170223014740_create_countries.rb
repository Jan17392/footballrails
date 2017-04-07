class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.integer :reference
      t.string :countryname

      t.timestamps
    end
  end
end
