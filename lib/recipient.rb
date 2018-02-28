require 'json'
require 'rest-client'

class Recipient
  RECIPIENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/recipients'

  def add(name, auth_token)
    payload = create_payload(name)
    headers = create_headers(auth_token)
    response, error = send_request(payload, headers)
    return error.response.to_s unless error.nil?
  end

  private

  def create_payload(name)
    values = {
      'recipient': {
        'name': name
      }
    }
  end

  def create_headers(auth_token)
    {
      content_type: 'application/json',
      authorization: "Bearer #{auth_token}"
    }
  end

  def send_request(payload, headers)
    begin
      response = RestClient.post RECIPIENTS_ENDPOINT, payload, headers
    rescue RestClient::ExceptionWithResponse => error
    end
    return response, error
  end
end
