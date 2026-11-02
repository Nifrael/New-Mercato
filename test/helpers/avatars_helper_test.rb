require "test_helper"

class AvatarsHelperTest < ActionView::TestCase
  test "un joueur avec photo a un avatar image décoratif" do
    html = player_avatar(Player.new(name: "Pedri", photo: "https://example.com/pedri.png"))

    assert_dom_equal '<img src="https://example.com/pedri.png" alt="" class="avatar" loading="lazy">', html
  end

  test "un avatar peut être agrandi" do
    html = player_avatar(Player.new(name: "Pedri", photo: nil), size: :lg)

    assert_dom_equal '<span class="avatar avatar--lg avatar--initials" aria-hidden="true">P</span>', html
  end

  test "un joueur sans photo a un avatar avec son initiale (pas de plantage)" do
    html = player_avatar(Player.new(name: "Pedri", photo: nil))

    assert_dom_equal '<span class="avatar avatar--initials" aria-hidden="true">P</span>', html
  end
end
