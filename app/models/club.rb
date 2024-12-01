class Club < ApplicationRecord
  belongs_to :user, optional: true
  validates :user, uniqueness: true, allow_nil: true
  has_many :players

  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
end
