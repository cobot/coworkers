match '/oauth2/authorize' => redirect('http://www.example.com/auth/callback?code=0517f73ab6ac088a380319672163b860&scope=read&state'), via: :get
