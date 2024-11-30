class Club < ApplicationRecord
  belongs_to :user, optional: true
  validates :user, uniqueness: true, allow_nil: true
end
