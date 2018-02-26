require 'dotenv/load'
require 'rest-client'
require 'json'

class Session
  attr_reader :auth_key

  def self.create
    @session = Session.new
  end

  def self.access
    @session
  end

  def login(username, apikey)
    response = RestClient.post 'https://coolpay.herokuapp.com/api/login', { 'username': username, 'apikey': apikey }.to_json, { :content_type => 'application/json' }
    @auth_key = JSON.parse(response)['token']
  end
end
