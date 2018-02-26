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
    response = RestClient.post LOGIN_URL, payload, HEADER
    @auth_key = JSON.parse(response)['token']
  end

  private

  def create_payload(username, apikey)
    { 'username': username, 'apikey': apikey }.to_json
  end
end