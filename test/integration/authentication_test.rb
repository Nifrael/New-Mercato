require "test_helper"

# Les comptes sont créés POUR les clubs (pas d'inscription en libre-service) :
# sinon n'importe qui pourrait se déclarer membre d'un club et décider à sa place.
class AuthenticationTest < ActionDispatch::IntegrationTest
  test "l'inscription publique n'existe pas" do
    get "/users/sign_up"

    assert_response :not_found
  end

  test "une connexion ratée explique l'erreur en français, dans un toast" do
    post user_session_path, params: { user: { email: users(:one).email, password: "mauvais-mot-de-passe" } }

    assert_response :unprocessable_entity
    assert_select ".toast.toast--danger", text: /mot de passe incorrect/i
  end

  test "une page réservée invite à se connecter, sans parler d'inscription" do
    get dashboard_url
    follow_redirect!

    assert_select ".toast", text: "Connectez-vous pour continuer."
  end

  test "on ne peut pas créer de compte en envoyant directement le formulaire" do
    assert_no_difference "User.count" do
      post "/users", params: { user: { email: "pirate@example.com", password: "password123" } }
    end

    assert_response :not_found
  end
end
