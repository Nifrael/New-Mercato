require "test_helper"

# Les comptes sont créés POUR les clubs (pas d'inscription en libre-service) :
# sinon n'importe qui pourrait se déclarer membre d'un club et décider à sa place.
class AuthenticationTest < ActionDispatch::IntegrationTest
  test "l'inscription publique n'existe pas" do
    get "/users/sign_up"

    assert_response :not_found
  end

  # --- Connexion -------------------------------------------------------------

  test "le formulaire de connexion utilise les bons types de champs et l'autocomplétion" do
    get new_user_session_url

    assert_response :success
    assert_select "h1", text: "Connexion"
    assert_select "form[action=?]", user_session_path do
      assert_select "input[type=email][name=?][autocomplete=email][required]", "user[email]"
      assert_select "input[type=password][name=?][autocomplete=current-password][required]", "user[password]"
      assert_select "input[type=checkbox][name=?]", "user[remember_me]"
    end
    assert_select "a[href=?]", new_user_password_path
  end

  test "une connexion réussie mène au tableau de bord du club" do
    post user_session_path, params: { user: { email: users(:one).email, password: "password123" } }

    assert_redirected_to dashboard_path
  end

  test "après connexion, on revient sur la page réservée demandée au départ" do
    get dashboard_bookings_url # page protégée : Devise mémorise l'adresse
    post user_session_path, params: { user: { email: users(:one).email, password: "password123" } }

    assert_redirected_to dashboard_bookings_path
  end

  # --- Mot de passe oublié ---------------------------------------------------

  test "la page mot de passe oublié demande l'e-mail et permet de revenir à la connexion" do
    get new_user_password_url

    assert_select "form[action=?] input[type=email][name=?]", user_password_path, "user[email]"
    assert_select "a[href=?]", new_user_session_path
  end

  test "la page de nouveau mot de passe demande le mot de passe deux fois" do
    get edit_user_password_url(reset_password_token: "jeton")

    assert_select "input[type=hidden][name=?][value=jeton]", "user[reset_password_token]"
    assert_select "input[type=password][name=?][autocomplete=new-password]", "user[password]"
    assert_select "input[type=password][name=?][autocomplete=new-password]", "user[password_confirmation]"
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
