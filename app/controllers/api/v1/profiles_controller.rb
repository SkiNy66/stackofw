class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    respond_with current_resource_owner
  end

  def users
    respond_with users_without_current
  end

  protected

  def users_without_current
    @users_without_current ||= User.where.not(id: current_resource_owner.id)
  end
end