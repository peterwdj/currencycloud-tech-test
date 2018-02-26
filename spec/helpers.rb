def stub_good_credentials
  stub_request(:post, 'https://coolpay.herokuapp.com/api/login').
    with(
      body: {
        'username': ENV['USERNAME'],
        'apikey': ENV['APIKEY']
      }.to_json,
      headers: {
        :content_type => 'application/json'
      }
    ).to_return(
      status: 200,
      body: { :token => '12345.yourtoken.67890' }.to_json
    )
end

def stub_bad_credentials
  stub_request(:post, 'https://coolpay.herokuapp.com/api/login').
    with(
      body: {
        'username': 'bad',
        'apikey': 'credentials'
      }.to_json,
      headers: {
        :content_type => 'application/json'
      }
    ).to_return(
      status: 404,
      body: 'Internal server error'
  )
end
