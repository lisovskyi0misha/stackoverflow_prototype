require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  add_flash_types :info, :error, :warning, :success

  private

  def owner?(object_user_id)
    object_user_id == current_user.id
  end
end
