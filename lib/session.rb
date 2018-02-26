require 'dotenv/load'
require 'rest-client'
require 'json'

class Session
  attr_reader :auth_key
  LOGIN_URL = 'https://coolpay.herokuapp.com/api/login'
  HEADER = { :content_type => 'application/json' }

  def self.create
    @session = Session.new
  end

  def self.access
    @session
  end

  def login(username=ENV['USERNAME'], apikey=ENV['APIKEY'])
    payload = create_payload(username, apikey)
    err, response = send_request(payload)
    send_response(err, response)
  end


  private

  def create_payload(username, apikey)
    { 'username': username, 'apikey': apikey }.to_json
  end

  def send_response(err, response)
    if err == nil
      @auth_key = JSON.parse(response)['token']
    else
      err.response.to_s
    end
  end

  def send_request(payload)
    begin
      response = RestClient.post LOGIN_URL, payload, HEADER
    rescue RestClient::ExceptionWithResponse => err
    end
    return err, response
  end
end
