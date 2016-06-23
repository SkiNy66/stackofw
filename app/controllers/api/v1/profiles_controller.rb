class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def users
    respond_with users_without_current
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def users_without_current
    @users_without_current ||= User.where.not(id: current_resource_owner.id)
  end
end