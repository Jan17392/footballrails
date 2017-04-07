class RemoveReferenceFromCountry < ActiveRecord::Migration[5.0]
  def change
    remove_column :countries, :reference, :integer
  end
end
