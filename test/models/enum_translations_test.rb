require "test_helper"

# Les vues affichent les enums via t("activerecord.enums.<model>.<attr>.<value>").
# Ce test vérifie que CHAQUE valeur de CHAQUE enum a sa traduction française :
# ajouter une valeur sans la traduire dans config/locales/fr.yml le fait échouer.
class EnumTranslationsTest < ActiveSupport::TestCase
  MODELS = [ Booking, Player, User ].freeze

  test "toutes les valeurs d'enum sont traduites en français" do
    missing = MODELS.flat_map do |model|
      model.defined_enums.flat_map do |attribute, values|
        values.keys.map { |value| "activerecord.enums.#{model.model_name.i18n_key}.#{attribute}.#{value}" }
      end
    end.reject { |key| I18n.exists?(key, :fr) }

    assert_empty missing, "Traductions manquantes dans config/locales/fr.yml"
  end
end
