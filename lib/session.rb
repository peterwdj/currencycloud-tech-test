require 'dotenv/load'
require 'json'
require 'rest-client'

class Session
  attr_reader :auth_key
  LOGIN_ENDPOINT = 'https://coolpay.herokuapp.com/api/login'
  HEADER = { :content_type => 'application/json' }

  def login(username=ENV['USERNAME'], apikey=ENV['APIKEY'])
    payload = create_payload(username, apikey)
    err, response = send_request(payload)
    send_response(err, response)
  end


  private

  def create_payload(username, apikey)
    { 'username': username, 'apikey': apikey }.to_json
  end

  def send_request(payload)
    begin
      response = RestClient.post LOGIN_ENDPOINT, payload, HEADER
    rescue RestClient::ExceptionWithResponse => err
    end
    return err, response
  end

  def send_response(err, response)
    if response != nil && response.code == 200
      @auth_key = JSON.parse(response)['token']
    else
      err.response.to_s
    end
  end
end
