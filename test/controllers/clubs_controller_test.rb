require "test_helper"

class ClubsControllerTest < ActionDispatch::IntegrationTest
  test "un visiteur peut voir la liste des clubs" do
    get clubs_url

    assert_response :success
    assert_select ".club-card__name", text: clubs(:one).name
  end

  test "un visiteur peut voir la page d'un club" do
    get club_url(clubs(:one))

    assert_response :success
  end
end
