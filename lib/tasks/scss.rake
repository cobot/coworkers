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
      RestClient.put bundle_url, {assets: assets}.to_json,
        content_type: :json, authorization: "Bearer #{ENV['SCSS_ACCESS_TOKEN']}"
      puts 'done.'
    else
      fail 'ENV[SCSS_BUNDLE_URL] not set. Run the create_scss_bundle task to create a bundle.'
    end
  end

  task create_scss_bundle: :environment do
    puts 'Creating new SCSS bundle…'
    res = JSON.parse(RestClient.post('https://scss.cobot.me/scss_bundles', {assets: []}.to_json,
      content_type: :json, authorization: "Bearer #{ENV.fetch('SCSS_ACCESS_TOKEN')}"))
    puts "Now set ENV[SCSS_BUNDLE_URL] to #{res['bundle_url']} so that we can upload scss."
    puts "Add a link to #{res['css_url']} to fetch CSS, replacing :subdomain with the space's subdomain."
  end

  def exclude_file?(path)
    path.include?('colors') || path.include?('color_shades')
  end

  def scss_imports(file)
    path = find_scss_file(file)
    content = File.read(path)
    imports = content.scan(/@import\s+\"([^"]+)\"/).flatten
    ([{file => path}] + imports.map do |import|
      scss_imports(import)
    end).flatten
  end

  def find_scss_file(name)
    underscored = "#{File.dirname(name)}/_#{File.basename(name)}"
    potential_paths = Rails.application.config.assets.paths.flat_map do |path|
      [
        "#{path}/#{name}.scss",
        "#{path}/#{underscored}.scss"
      ]
    end
    found = potential_paths.find do |path|
      File.exist?(path)
    end
    found || fail("sccs import not found: #{name}")
  end
end

Rake::Task['assets:clean'].enhance do
  Rake::Task['cobot_scss:post_scss'].invoke
end
