require "test_helper"

class FlashHelperTest < ActionView::TestCase
  test "un message de succès (notice) est un toast de succès, annoncé poliment" do
    assert_equal :success, flash_variant(:notice)
    assert_equal "status", flash_role(:notice)
  end

  test "une erreur (alert) est un toast de danger, annoncé immédiatement" do
    assert_equal :danger, flash_variant(:alert)
    assert_equal "alert", flash_role(:alert)
  end

  test "un type inconnu reste neutre et poli" do
    assert_nil flash_variant(:info)
    assert_equal "status", flash_role(:info)
  end
end
