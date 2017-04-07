class AddFieldsToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :home_goals_first_half, :integer
    add_column :matches, :away_goals_first_half, :integer
    add_column :matches, :home_goals_second_half, :integer
    add_column :matches, :away_goals_second_half, :integer
    add_column :matches, :match_url, :string
    add_column :matches, :match_referencer, :string
    remove_column :matches, :season, :string
  end
end
