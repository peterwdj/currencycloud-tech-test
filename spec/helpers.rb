def stub_valid_login
  stub_request(:post, 'https://coolpay.herokuapp.com/api/login')
    .with(
      body: {
        'username': ENV['USERNAME'],
        'apikey': ENV['APIKEY']
      }.to_json,
      headers: {
        content_type: 'application/json'
      }
    ).to_return(
      status: 200,
      body: { token: '12345.yourtoken.67890' }.to_json
    )
end

def stub_invalid_login
  stub_request(:post, 'https://coolpay.herokuapp.com/api/login')
    .with(
      body: {
        'username': 'bad',
        'apikey': 'credentials'
      }.to_json,
      headers: {
        content_type: 'application/json'
      }
    ).to_return(
      status: 404,
      body: 'Internal server error'
    )
end

def stub_recipient_with_invalid_auth_key
  stub_request(:post, 'https://coolpay.herokuapp.com/api/recipients')
    .with(
      body: {
        'recipient': {
          'name': 'Marvin'
        }
      },
      headers: {
        authorization: 'Bearer 42',
        content_type: 'application/x-www-form-urlencoded'
      }
    ).to_return(
      status: 401,
      body: '401 Unauthorized'
    )
end
