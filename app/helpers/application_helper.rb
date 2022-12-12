module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def has_vote?(object)
    return true if current_user.nil?
    object.voted_users.ids.include?(current_user.id)
  end

  def owner?(object_user_id)
    return false if current_user.nil?
    object_user_id == current_user.id
  end
end
