class ProfilePolicy < ApplicationPolicy
  def me?
    true
  end
end