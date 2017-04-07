class Odd < ApplicationRecord
  belongs_to :match

  validates :match_id, uniqueness: {scope: :provider}
end
