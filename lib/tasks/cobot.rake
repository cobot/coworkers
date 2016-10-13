namespace :cobot do
  desc "checks against the cobot api if all members still are active (args: space_id)"
  task update_inactive_memberships: :environment do 
    space = Space.where(cobot_id: ARGV[1]).first!
    puts "updating members for #{ARGV[1]}"
    cb_client =  CobotClient::ApiClient.new(space.access_token)
    space.memberships.each do |m|
      begin 
        api_membership = cb_client.get(space.subdomain, "/memberships/#{m.cobot_id}")
        m.update_attribute :canceled_to, api_membership[:canceled_to]
      rescue CobotClient::ResourceNotFound
        p "#{m.name} does not exist"
        m.destroy
      end
    end;nil
    
  end
end