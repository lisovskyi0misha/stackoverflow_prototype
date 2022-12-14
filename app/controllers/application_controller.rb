class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning, :success

  private

  def owner?(object_user_id)
    object_user_id == current_user.id
  end
end
