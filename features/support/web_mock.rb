Before do
  WebMock.reset!
  WebMock.disable_net_connect!(allow_localhost: true)
end