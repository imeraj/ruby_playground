# frozen_string_literal: true

class LinkPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create?
    @user.admin?
  end
end
