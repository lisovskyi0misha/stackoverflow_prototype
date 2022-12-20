require "application_responder"

class ApplicationController < ActionController::Base
  RESOURCE_MEMBER_LIST = %w(edit update destroy)
  self.responder = ApplicationResponder
  respond_to :html

  add_flash_types :info, :error, :warning, :success

  authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    if RESOURCE_MEMBER_LIST.include?(params[:action])
      redirect_to question_path(id: params[:id]), notice: exception.message
    else
      redirect_to root_path, notice: exception.message
    end
  end

  private

  def owner?(object_user_id)
    object_user_id == current_user.id
  end
end
