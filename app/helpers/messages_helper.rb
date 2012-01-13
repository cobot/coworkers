module MessagesHelper
  def author_link(message)
    if message.author_id?
      link_to message.author_name, space_membership_path(@space, message.author_id)
    else
      message.author_name
    end
  end
end
