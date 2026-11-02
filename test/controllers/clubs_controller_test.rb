require "test_helper"

class ClubsControllerTest < ActionDispatch::IntegrationTest
  test "un visiteur peut voir la liste des clubs" do
    get clubs_url

    assert_response :success
    assert_select ".club-card__name", text: clubs(:one).name
  end

  test "la liste présente le dirigeant de chaque club, pas un employé" do
    get clubs_url

    assert_select ".club-card__owner", text: /#{users(:one).first_name}/
    assert_select ".club-card__owner", text: /#{users(:employe_one).first_name}/, count: 0
  end

  test "un club sans dirigeant n'empêche pas d'afficher la liste" do
    users(:two).destroy! # le club two n'a plus aucun membre, donc pas de dirigeant

    get clubs_url

    assert_response :success
    assert_select ".club-card__name", text: clubs(:two).name
  end

  test "un visiteur peut voir la page d'un club" do
    get club_url(clubs(:one))

    assert_response :success
  end
end
