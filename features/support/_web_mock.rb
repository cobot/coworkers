WebMock.disable_net_connect!(allow_localhost: true)

Before do
  WebMock.reset!
  WebMock.stub_request(:post, /subscriptions/).to_return(body: '{}')
end
