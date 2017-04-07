class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :expert

  validates :match_id, uniqueness: {scope: :expert_id}
end
