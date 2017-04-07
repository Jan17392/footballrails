class AddSeasonToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :season, :string
  end
end
