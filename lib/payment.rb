require 'json'
require 'rest-client'

class Payment
  PAYMENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/payments'
  RECIPIENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/recipients'
  NONEXISTENT_RECIPIENT_ERROR = 'Error: your selected recipient does not exist. Please add them as a recipient before attempting to send a payment to them.'
  SUCCESSFUL_PAYMENT = 'Your last payment was successful.'
  UNSUCCESSFUL_PAYMENT = 'Your last payment was not successful. Please try again.'
  PENDING_PAYMENT = 'Your last payment is still processing. Please check again in a few seconds.'

  def send_to(name, amount, auth_key)
    headers, payload = create_params(name, amount, auth_key)
    return NONEXISTENT_RECIPIENT_ERROR if payload[:payment][:recipient_id].nil?
    response, error = send_request(payload, headers)
    return error.response.to_s unless error.nil?
  end

  def verify_payment(auth_key)
    headers = create_headers(auth_key)
    response = RestClient.get PAYMENTS_ENDPOINT, headers
    return_status_message(response)
  end

  private

  def create_params(name, amount, auth_key)
    headers = create_headers(auth_key)
    id = get_id_by_name(name, headers)
    payload = create_payload(amount, id)
    return headers, payload
  end

  def get_id_by_name(name, headers)
    name.gsub!(' ', '%20')
    response = RestClient.get RECIPIENTS_ENDPOINT + "?name=#{name}", headers
    return nil if JSON.parse(response)['recipients'].length.zero?
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

  def return_status_message(response)
    status = JSON.parse(response)['payments'][-1]['status']
    case status
    when 'paid'
      SUCCESSFUL_PAYMENT
    when 'failed'
      UNSUCCESSFUL_PAYMENT
    when 'processing'
      PENDING_PAYMENT
    else
      "Error: payment #{status}"
    end
  end
end
