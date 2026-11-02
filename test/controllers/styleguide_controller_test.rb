require "test_helper"

# Le styleguide affiche tous les composants : s'il s'affiche sans erreur,
# c'est que chaque composant se génère correctement.
class StyleguideControllerTest < ActionDispatch::IntegrationTest
  test "le styleguide affiche tous les composants" do
    get styleguide_url

    assert_response :success
    assert_select ".btn.btn--primary"
    assert_select ".btn.btn--secondary"
    assert_select ".btn.btn--danger"
    assert_select ".badge.badge--success"
    assert_select ".badge.badge--warning"
    assert_select ".badge.badge--danger"
    assert_select ".card .card__title"
    assert_select ".stat .stat__label"
    assert_select ".stat .stat__value"
  end
end
