require "application_responder"

class ApplicationController < ActionController::Base
  RESOURCE_MEMBER_LIST = %w[edit update destroy choose_best delete_best vote].freeze
  self.responder = ApplicationResponder
  respond_to :html

  add_flash_types :info, :error, :warning, :success

  rescue_from CanCan::AccessDenied do |exception|
    id = params[:controller] == 'questions' ? params[:id] : params[:question_id]
    if RESOURCE_MEMBER_LIST.include?(params[:action])
      redirect_to question_path({ id: }), notice: exception.message
    else
      redirect_to root_path, notice: exception.message
    end
  end

  def has_subscription?(question)
    return false if current_user.nil?

    question.subscribed_users.ids.include?(current_user.id)
  end
end
