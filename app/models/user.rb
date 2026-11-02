class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :club

  enum :role, { employe: 0, dirigeant: 1 }

  # Club obligatoire : assuré par belongs_to. Email obligatoire et unique : assuré par Devise (:validatable).
  validates :first_name, :last_name, :role, presence: true

  # « Julien Marchand » → « JM » (avatar de la navigation).
  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
end
