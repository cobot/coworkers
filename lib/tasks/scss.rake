namespace :cobot_scss do
  desc 'posts scss to the scss server so it can generate per space css'
  task post_scss: :environment do
    root = 'new/application'
    assets = scss_imports(root).map do |hash|
      import = hash.keys.first
      path = hash[import]
      {name: import, body: Base64.encode64(exclude_file?(path) ? '' : File.read(path))}
    end
    if (bundle_url = ENV['SCSS_BUNDLE_URL'])
      puts 'Updating SCSS bundle…'
      begin
        RestClient.put bundle_url, {assets: assets}.to_json, accept: :json,
          content_type: :json, authorization: "Bearer #{ENV['SCSS_ACCESS_TOKEN']}"
        puts 'done.'
      rescue RestClient::UnprocessableEntity => e
        puts "Error posting SCSS: #{JSON.parse(e.response)['error']}"
      end
    else
      fail 'ENV[SCSS_BUNDLE_URL] not set. Run the create_scss_bundle task to create a bundle.'
    end
  end

  task create_scss_bundle: :environment do
    puts 'Creating new SCSS bundle…'
    begin
      res = JSON.parse(RestClient.post('https://scss.cobot.me/scss_bundles', {assets: []}.to_json,
        accept: :json,
        content_type: :json, authorization: "Bearer #{ENV.fetch('SCSS_ACCESS_TOKEN')}"))
      puts "Now set ENV[SCSS_BUNDLE_URL] to #{res['bundle_url']} so that we can upload scss."
      puts "Add a link to #{res['css_url']} to fetch CSS, replacing :subdomain with the space's subdomain."
    rescue RestClient::BadRequest => e
      puts "Error: #{JSON.parse(e.response)['error']}"
    end
  end

  def exclude_file?(path)
    path.include?('/_colors.scss') || path.include?('default_color_shades.scss')
  end

  def scss_imports(file)
    require 'cobot_assets/scss_import_resolver'
    CobotAssets::ScssImportResolver.new(Rails.application.config.assets.paths)
      .scss_imports(file: file)
  end
end

Rake::Task['assets:clean'].enhance do
  Rake::Task['cobot_scss:post_scss'].invoke
end
