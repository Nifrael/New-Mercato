require "test_helper"

class FormattingHelperTest < ActionView::TestCase
  test "les grands montants sont abrégés en k€ / M€ / Md€" do
    assert_equal "300 M€", compact_currency(300_000_000)
    assert_equal "1,5 M€", compact_currency(1_500_000)
    assert_equal "45 k€", compact_currency(45_000)
    assert_equal "2 Md€", compact_currency(2_000_000_000)
  end

  test "les petits montants restent entiers" do
    assert_equal "984 €", compact_currency(984)
  end
end
