module MembershipHelpers
  def set_up_membership_profile
    visit account_path
    find('.space a').click
    click_link 'Set up Profile'
    check 'Publish Profile'
    click_button 'Update Profile'
  end
end
