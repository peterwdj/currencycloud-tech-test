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

def stub_recipient_with_valid_auth_token
  stub_request(:post, 'https://coolpay.herokuapp.com/api/recipients')
    .with(
      body: {
        'recipient': {
          'name': 'Jack'
        }
      },
      headers: {
        authorization: 'Bearer dummy-key',
        content_type: 'application/x-www-form-urlencoded'
      }
    )
    .to_return(
      status: 200
    )
end

def stub_recipient_with_invalid_auth_token
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

def stub_payment_with_valid_auth_token
  stub_request(:post, 'https://coolpay.herokuapp.com/api/payments')
    .with(
      body: {
        payment: {
          amount: '1000000',
          currency: 'GBP',
          recipient_id: '12345'
        }
      },
      headers: {
        authorization: 'Bearer 1n5t4gr4m',
        content_type: 'application/x-www-form-urlencoded'
      }
    ).to_return(
      status: 200
    )
end

def stub_payment_with_invalid_auth_token
  stub_request(:post, 'https://coolpay.herokuapp.com/api/payments')
    .with(
      body: {
        payment: {
          amount: '1000000',
          currency: 'GBP',
          recipient_id: '12345'
        }
      },
      headers: {
        authorization: 'Bearer 5n34ky-br1b3',
        content_type: 'application/x-www-form-urlencoded'
      }
    ).to_return(
      status: 401,
      body: '401 Unauthorized'
    )
end

def stub_successful_payment
  stub_request(:get, 'https://coolpay.herokuapp.com/api/payments')
    .with(
      headers: {
        authorization: 'Bearer g14nt-l4z3r',
        content_type: 'application/json'
      }
    ).to_return(
      status: 200,
      body: {
        payments: [
          {
            id: 'mr-pr351d3nt',
            amount: 10.50,
            currency: 'GBP',
            recipient_id: 'dr-3v1l',
            status: 'paid'
          }
        ]
      }.to_json
    )
end

def stub_unsuccessful_payment
  stub_request(:get, 'https://coolpay.herokuapp.com/api/payments')
    .with(
      headers: {
        authorization: 'Bearer g14nt-l4z3r',
        content_type: 'application/json'
      }
    ).to_return(
      status: 200,
      body: {
        payments: [
          {
            id: 'mr-pr351d3nt',
            amount: 10.50,
            currency: 'GBP',
            recipient_id: 'dr-3v1l',
            status: 'failed'
          }
        ]
      }.to_json
    )
end

def stub_processing_payment
  stub_request(:get, 'https://coolpay.herokuapp.com/api/payments')
    .with(
      headers: {
        authorization: 'Bearer g14nt-l4z3r',
        content_type: 'application/json'
      }
    ).to_return(
      status: 200,
      body: {
        payments: [
          {
            id: 'mr-pr351d3nt',
            amount: 10.50,
            currency: 'GBP',
            recipient_id: 'dr-3v1l',
            status: 'processing'
          }
        ]
      }.to_json
    )
end
