RSpec::Matchers::define :have_css_link do |path|
  match do |page|
    Capybara.string(page.body).has_css?("link[href*='#{path}']", visible: false)
  end
end
