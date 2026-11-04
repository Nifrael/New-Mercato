require "test_helper"

# Tableau de bord : « qu'est-ce que je dois faire aujourd'hui ? »
# users(:one) dirige le club one ; bookings(:one) = le club two demande players(:one) (pending).
class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "un visiteur non connecté est redirigé vers la connexion" do
    get dashboard_url

    assert_redirected_to new_user_session_url
  end

  test "les rechargements de page sont morphés en gardant le défilement (Turbo 8)" do
    sign_in users(:one)

    get dashboard_url

    assert_select "meta[name='turbo-refresh-method'][content='morph']"
    assert_select "meta[name='turbo-refresh-scroll'][content='preserve']"
  end

  test "les chiffres clés du club sont affichés, montants abrégés" do
    sign_in users(:one)

    get dashboard_url

    assert_response :success
    assert_select "h1", text: "Bonjour #{users(:one).first_name}"
    assert_select ".stat__value", text: "1 M€" # budget du club one : 1 000 000
  end

  test "les demandes reçues en attente sont listées avec les actions de décision" do
    sign_in users(:one)

    get dashboard_url

    assert_select ".booking-card", count: 1
    assert_select ".booking-card", text: /#{players(:one).name}/
    assert_select ".booking-card", text: /#{clubs(:two).name}/ # le club demandeur
    assert_select ".booking-card form[action=?]", accept_dashboard_booking_path(bookings(:one))
    assert_select ".booking-card form[action=?]", refuse_dashboard_booking_path(bookings(:one))
  end

  test "un état vide s'affiche quand rien n'est à traiter" do
    bookings(:one).update!(status: :refused)
    sign_in users(:one)

    get dashboard_url

    assert_select ".booking-card", count: 0
    assert_select ".empty-state", text: /Rien à traiter/
  end

  test "un prêt en cours affiche ses jours restants" do
    bookings(:one).update!(status: :accepted, start_date: Date.current - 2, end_date: Date.current + 5)
    sign_in users(:one)

    get dashboard_url

    assert_select ".loan-card", text: /#{players(:one).name}/
    assert_select ".loan-card .badge", text: "J-5"
    assert_select ".loan-card progress"
  end
end
