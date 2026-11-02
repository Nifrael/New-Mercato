require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  # --- Page de bienvenue (racine du site) ------------------------------------

  test "la page de bienvenue s'affiche avec un seul titre principal" do
    get root_url

    assert_response :success
    assert_select "h1", count: 1 # un seul h1 par page : accessibilité et référencement
  end

  test "la page de bienvenue mène à l'accueil" do
    get root_url

    assert_select "a.hero__cta[href=?]", accueil_path
  end
end
