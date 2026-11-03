require "test_helper"

# Rappel des fixtures : users(:one) est du club one, users(:two) du club two.
class ClubPolicyTest < ActiveSupport::TestCase
  setup do
    @club = clubs(:one)
    # Visiteur, membre du club, membre d'un autre club : les trois profils possibles.
    @all_users = [ nil, users(:one), users(:two) ]
  end

  # --- Consultation : les clubs sont publics ---------------------------------

  test "tout le monde peut voir la liste et la page des clubs" do
    @all_users.each do |user|
      assert_permit user, @club, :index?
      assert_permit user, @club, :show?
    end
  end

  test "le scope renvoie tous les clubs, même pour un visiteur" do
    assert_equal Club.count, ClubPolicy::Scope.new(nil, Club).resolve.count
  end

  # --- Gestion : personne, pas même les membres du club ----------------------

  test "personne ne peut créer, modifier ni supprimer un club depuis l'application" do
    @all_users.each do |user|
      %i[new? create? edit? update? destroy?].each do |action|
        refute_permit user, @club, action
      end
    end
  end
end
