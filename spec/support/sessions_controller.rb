SessionsController.class_eval do
  def user_info
    render text: current_user.cobot_id
  end
end
