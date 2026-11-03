class User < ApplicationRecord
  # Pas de :registerable : les comptes sont créés POUR les clubs (seeds, console,
  # invitation plus tard). Une inscription libre permettrait à n'importe qui de se
  # déclarer membre d'un club et d'accepter ou refuser ses demandes à sa place.
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  belongs_to :club

  enum :role, { employe: 0, dirigeant: 1 }

  # Club obligatoire : assuré par belongs_to. Email obligatoire et unique : assuré par Devise (:validatable).
  validates :first_name, :last_name, :role, presence: true

  # « Julien Marchand » → « JM » (avatar de la navigation).
  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end
end
