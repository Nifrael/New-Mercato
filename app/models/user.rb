class User < ApplicationRecord
  belongs_to :club

  enum :role, { employe: 0, dirigeant: 1 }

  validates :first_name, :last_name, :role, presence: true
  validates :club_id, :email, presence: true, uniqueness: true
end
