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
    assert_select ".page-header .page-header__eyebrow"
    assert_select ".avatar"
    assert_select "progress.progress"
    assert_select ".empty-state .empty-state__title"
    assert_select ".search-field .search-field__input"
    assert_select ".chips .chip .chip__input[checked]"
    assert_select ".select-field .select-field__input"
    assert_select ".field input[type=date].field__input"
    assert_select ".avatar.avatar--xl"
    assert_select ".checkbox .checkbox__input"
    assert_select ".form-errors[role=alert]"
    assert_select ".segmented .segmented__item[aria-current=page]"
    assert_select ".pipeline .pipeline__dot--warning"
    assert_select ".toast.toast--success"
    assert_select ".toast.toast--danger"
  end
end
