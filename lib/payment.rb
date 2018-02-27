require 'json'
require 'rest-client'

class Payment
  PAYMENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/payments'
  RECIPIENTS_ENDPOINT = 'https://coolpay.herokuapp.com/api/recipients'

  def send_new(name, amount, auth_key)
    headers = {
      :content_type => 'application/json',
      :authorization => "Bearer #{auth_key}"
    }

    payload = {
      'payment': {
        'amount': amount,
        'currency': 'GBP',
        'recipient_id': get_id_by_name(name, headers)
      }
    }
    response = RestClient.post PAYMENTS_ENDPOINT, payload, headers
  end


  private

  def get_id_by_name(name, headers)
    response = RestClient.get RECIPIENTS_ENDPOINT + "?name=#{name}", headers
    puts response
  end
end
