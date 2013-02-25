Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, Coworkers::Conf.app_id,
    Coworkers::Conf.app_secret, scope: 'navigation read',
      client_options: {site: Coworkers::Conf.app_site,
        authorize_url: "#{Coworkers::Conf.site}/oauth2/authorize",
        token_url: "#{Coworkers::Conf.site}/oauth2/access_token"}
end
