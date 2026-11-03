require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Construit un utilisateur valide, à compléter / modifier selon le test.
  def build_user(**attributes)
    User.new(
      first_name: "Nouveau",
      last_name: "Membre",
      email: "nouveau@example.com",
      password: "password123",
      role: :employe,
      club: clubs(:one),
      **attributes
    )
  end

  test "un club peut avoir plusieurs utilisateurs" do
    # users(:one) est déjà rattaché au club one.
    second_user = build_user(club: clubs(:one))

    assert second_user.valid?, second_user.errors.full_messages.to_sentence
  end

  # Le club et l'email restent obligatoires, avec UN seul message par problème
  # (la règle est déjà portée par belongs_to :club et par Devise :validatable).

  test "un utilisateur doit appartenir à un club" do
    user = build_user(club: nil)

    assert_not user.valid?
    assert_equal [ "Club doit exister" ], user.errors.full_messages
  end

  test "les initiales reprennent la première lettre du prénom et du nom" do
    assert_equal "JM", build_user(first_name: "julien", last_name: "marchand").initials
  end

  test "deux utilisateurs ne peuvent pas avoir le même email" do
    user = build_user(email: users(:one).email)

    assert_not user.valid?
    assert_equal [ "Email est déjà utilisé(e)" ], user.errors.full_messages
  end
end
