require "test_helper"

# pluralize de Rails suit la règle ANGLAISE (singulier seulement pour 1) et n'a aucune règle
# de pluriel français. On passe par la pluralisation i18n : les deux formes sont écrites dans
# fr.yml et rails-i18n choisit selon la règle française (0 et 1 au singulier).
class FrenchPluralizationTest < ActiveSupport::TestCase
  test "0 et 1 au singulier, à partir de 2 au pluriel" do
    assert_equal "0 joueur", I18n.t("counts.players", count: 0)
    assert_equal "1 joueur", I18n.t("counts.players", count: 1)
    assert_equal "2 joueurs", I18n.t("counts.players", count: 2)
    assert_equal "3 clubs", I18n.t("counts.clubs", count: 3)
  end
end
