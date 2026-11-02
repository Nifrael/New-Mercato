# Policy « sans enregistrement » (headless) : le tableau de bord n'est pas un objet en base,
# c'est l'espace du club de l'utilisateur. Appel : authorize :dashboard, :show?
class DashboardPolicy < ApplicationPolicy
  def show?
    user.present? && user.club.present?
  end
end
