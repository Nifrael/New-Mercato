require "test_helper"

# Policy « sans enregistrement » (headless) : authorize :dashboard, :show?
class DashboardPolicyTest < ActiveSupport::TestCase
  test "un membre d'un club peut voir son tableau de bord" do
    assert_permit users(:one), :dashboard, :show?
  end

  test "un visiteur ou un utilisateur sans club ne le peut pas" do
    refute_permit nil, :dashboard, :show?
    refute_permit User.new(club: nil), :dashboard, :show?
  end
end
