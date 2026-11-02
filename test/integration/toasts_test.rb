require "test_helper"

# Les messages flash s'affichent en toasts : couleur et rôle d'accessibilité selon le type,
# fermeture automatique et au clic (contrôleur Stimulus « toast »), jamais mis en cache par Turbo.
class ToastsTest < ActionDispatch::IntegrationTest
  test "un succès s'affiche en toast de succès, avec un bouton pour le fermer" do
    sign_in users(:one)

    patch accept_dashboard_booking_url(bookings(:one)), headers: { "HTTP_REFERER" => dashboard_url }
    follow_redirect!

    assert_select ".toast.toast--success[role=status][data-controller=toast]", text: /acceptée/
    assert_select ".toast button[aria-label=Fermer][data-action=?]", "toast#dismiss"
    assert_select ".toasts[data-turbo-temporary]"
  end

  test "une erreur s'affiche en toast de danger, annoncé immédiatement" do
    bookings(:one).update!(status: :refused)
    sign_in users(:one)

    patch accept_dashboard_booking_url(bookings(:one)), headers: { "HTTP_REFERER" => dashboard_url }
    follow_redirect!

    assert_select ".toast.toast--danger[role=alert]", text: /ne peut plus être acceptée/
  end

  test "aucun conteneur de toasts quand il n'y a pas de message" do
    get players_url

    assert_select ".toasts", count: 0
  end
end
