require 'json'
require 'rest-client'

class Payment
  PAYMENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/payments'
  RECIPIENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/recipients'

  def send_to(name, amount, auth_key)
    headers = create_headers(auth_key)
    id = get_id_by_name(name, headers)
    payload = create_payload(amount, id)
    response, error = send_request(payload, headers)
  end

  private

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
