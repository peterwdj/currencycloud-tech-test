require 'json'
require 'rest-client'

class Payment
  PAYMENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/payments'
  RECIPIENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/recipients'
  NONEXISTENT_RECIPIENT_ERROR = 'Error: your selected recipient does not exist. Please add them as a recipient before attempting to send a payment to them.'

  def send_to(name, amount, auth_key)
    headers, payload = create_params(name, amount, auth_key)
    return NONEXISTENT_RECIPIENT_ERROR if payload[:payment][:recipient_id] == nil
    response, error = send_request(payload, headers)
    return error.response.to_s unless error.nil?
  end

  private

  def create_params(name, amount, auth_key)
    headers = create_headers(auth_key)
    id = get_id_by_name(name, headers)
    payload = create_payload(amount, id)
    return headers, payload
  end

  def get_id_by_name(name, headers)
    response = RestClient.get RECIPIENTS_ENDPOINT + "?name=#{name}", headers
    JSON.parse(response)['recipients'][0]['id']
  end

  def create_headers(auth_key)
    {
      content_type: 'application/json',
      authorization: "Bearer #{auth_key}"
    }
  end

  def create_payload(amount, id)
    {
      'payment': {
        'amount': amount,
        'currency': 'GBP',
        'recipient_id': id
      }
    }
  end

  def send_request(payload, headers)
    begin
      response = RestClient.post PAYMENTS_ENDPOINT, payload, headers
    rescue RestClient::ExceptionWithResponse => error
    end
    return response, error
  end
end
