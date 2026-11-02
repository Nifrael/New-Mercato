require "test_helper"

class ClubTest < ActiveSupport::TestCase
  # --- Dirigeant du club -----------------------------------------------------

  test "le dirigeant est le membre au rôle dirigeant, pas un employé" do
    # Le club one a deux membres : users(:one) (dirigeant) et users(:employe_one).
    assert_equal users(:one), clubs(:one).dirigeant
  end

  test "un club sans dirigeant renvoie nil" do
    users(:one).update!(role: :employe)

    assert_nil clubs(:one).dirigeant
  end
end
