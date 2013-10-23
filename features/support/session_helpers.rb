module SessionHelpers
  def sign_in
    visit root_url
    if page.has_content?('Sign out')
      click_link 'Sign out'
    end
    click_link 'Sign in'
    if page.all("input[value='Update Profile']").first
      fill_in 'Bio', with: 'i work here'
      click_button 'Update Profile'
    end
  end
end

World(SessionHelpers) if respond_to?(:World)
