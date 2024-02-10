class PurchasePolicy < ApplicationPolicy


  def index?
    user
  end

  def create?
    user
  end

  def show?
    user.admin? || user == record.user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end