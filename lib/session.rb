require 'dotenv/load'
require 'json'
require_relative './payment'
require_relative './recipient'
require 'rest-client'

class Session
  attr_reader :auth_token
  LOGIN_ENDPOINT = 'https://coolpay.herokuapp.com/api/login'
  HEADER = { content_type: 'application/json' }

  def login(username = ENV['USERNAME'], apikey = ENV['APIKEY'])
    payload = create_payload(username, apikey)
    response, error = send_request(payload)
    send_response(response, error)
  end

  def add_recipient(name)
    recipient = Recipient.new
    recipient.add(name, @auth_token)
  end

  def make_payment(name, amount)
    payment = Payment.new
    payment.send_to(name, amount, @auth_token)
  end

  def verify_last_payment
    payment = Payment.new
    payment.verify_payment(@auth_token)
  end

  private

  def create_payload(username, apikey)
    { 'username': username, 'apikey': apikey }.to_json
  end

  def send_request(payload)
    begin
      response = RestClient.post LOGIN_ENDPOINT, payload, HEADER
    rescue RestClient::ExceptionWithResponse => error
    end
    return response, error
  end

  def send_response(response, error)
    if !response.nil? && response.code == 200
      @auth_token = JSON.parse(response)['token']
    else
      error.response.to_s
    end
  end
end
