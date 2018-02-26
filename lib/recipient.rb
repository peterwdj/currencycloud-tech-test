require 'json'
require 'rest-client'

class Recipient
  RECIPIENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/recipients'

  def add(name, auth_key)
    payload = create_payload(name)
    headers = create_headers(auth_key)
    response = RestClient.post RECIPIENTS_ENDPOINT, payload, headers
  end


  private

  def create_payload(name)
    values = {
      'recipient': {
        'name': name
      }.to_json
    }
  end

  def create_headers(auth_key)
    {
      :content_type => 'application/json',
      :authorization => "Bearer #{auth_key}"
    }
  end
end
