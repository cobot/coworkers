module SessionHelpers
  def sign_in
    visit root_url
    click_link 'Sign in'
    if current_path == edit_account_path
      fill_in 'Bio', with: 'i work here'
      click_button 'Update Profile'
    end
  end
end

World(SessionHelpers) if respond_to?(:World)