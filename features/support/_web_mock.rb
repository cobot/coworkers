WebMock.disable_net_connect!(allow_localhost: true)

Before do
  WebMock.reset!
end