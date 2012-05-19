require 'spec_helper'

describe SessionsController, 'switching the layout' do
  it 'renders the given layout' do
    get :new, app_layout: 'embed'

    response.should render_template("layouts/embed")
  end

  it 'renders application by default' do
    get :new

    response.should render_template("layouts/application")
  end

  it 'keeps rendering the selected layout' do
    get :new, app_layout: 'embed'
    get :new

    response.should render_template("layouts/embed")
  end
end
