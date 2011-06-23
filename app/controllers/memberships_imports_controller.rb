class MembershipsImportsController < ApplicationController
  before_filter :must_be_admin_for_space

  def create
    token = session['access_token']
    p token
    memberships = token.get("https://#{@space.subdomain}.cobot.me/api/memberships")
    memberships.each do
    end
  end

end