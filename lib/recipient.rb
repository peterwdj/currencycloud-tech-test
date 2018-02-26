require 'json'
require 'rest-client'

class Recipient

  def add(name, auth_key)
    values = {
      'recipient': {
        'name': name
      }.to_json
    }

    headers = {
      :content_type => 'application/json',
      :authorization => "Bearer #{auth_key}"
    }

    response = RestClient.post 'https://coolpay.herokuapp.com/api/recipients', values, headers
  end
end
