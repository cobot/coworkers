WebMock.disable_net_connect!(allow_localhost: true)

Before do
  WebMock.reset!
  WebMock.stub_request(:post, /subscriptions/).to_return(body: '{}')

  WebMock.stub_request(:post, 'https://www.cobot.me/api/access_tokens/test_token/space')
    .with(body: {space_id: 'co-up'},
          headers: {'Authorization' => 'Bearer test_token'})
    .to_return(body: {token: 'test_space_token_co-up'}.to_json)
  WebMock.stub_request(:post, 'https://www.cobot.me/api/access_tokens/test_token/space')
    .with(body: {space_id: 'other-space'},
          headers: {'Authorization' => 'Bearer test_token'})
    .to_return(body: {token: 'test_space_token_other-space'}.to_json)
end
