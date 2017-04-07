class Match < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, :foreign_key => 'home_team_id', class_name: 'Team'
  belongs_to :away_team, :foreign_key => 'away_team_id', class_name: 'Team'

  has_many :predictions
  has_many :odds

  validates :home_team_id, uniqueness: {scope: :date}
end
