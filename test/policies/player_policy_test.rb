require "test_helper"

# Rappel des fixtures :
#   players(:one) appartient au club one ; users(:one) est du club one.
#   users(:two) est du club two.
class PlayerPolicyTest < ActiveSupport::TestCase
  setup do
    @player = players(:one)
    @same_club_user = users(:one)
    @other_club_user = users(:two)
  end

  # --- Consultation : le catalogue de joueurs est public ---------------------

  test "tout le monde peut voir la liste et la fiche des joueurs" do
    [ nil, @same_club_user, @other_club_user ].each do |user|
      assert_permit user, @player, :index?
      assert_permit user, @player, :show?
    end
  end

  test "le scope renvoie tous les joueurs, même pour un visiteur" do
    assert_equal Player.count, PlayerPolicy::Scope.new(nil, Player).resolve.count
  end

  # --- Modification : réservée au club propriétaire du joueur ----------------

  test "un visiteur non connecté ne peut pas modifier un joueur" do
    refute_permit nil, @player, :edit?
    refute_permit nil, @player, :update?
  end

  test "un utilisateur d'un autre club ne peut pas modifier le joueur" do
    refute_permit @other_club_user, @player, :edit?
    refute_permit @other_club_user, @player, :update?
  end

  test "un utilisateur du club du joueur peut le modifier" do
    assert_permit @same_club_user, @player, :edit?
    assert_permit @same_club_user, @player, :update?
  end

  test "un utilisateur sans club ne peut pas modifier un joueur sans club" do
    # Sans la vérification record.club.present?, on aurait nil == nil → autorisé.
    clubless_user = User.new(club: nil)
    clubless_player = Player.new(club: nil)

    refute_permit clubless_user, clubless_player, :edit?
  end

  # --- Création / suppression : personne (règles héritées d'ApplicationPolicy)

  test "personne ne peut créer ni supprimer un joueur depuis l'application" do
    [ nil, @same_club_user ].each do |user|
      refute_permit user, @player, :create?
      refute_permit user, @player, :destroy?
    end
  end
end
