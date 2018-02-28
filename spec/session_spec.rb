require 'session'
require 'recipient'

describe Session do
  let(:session) { described_class.new }

  describe '#login' do
    it 'returns an authentication key' do
      stub_valid_login
      session.login
      expect(session.auth_key).to eq '12345.yourtoken.67890'
    end

    it 'returns error response text when invalid credentials are supplied' do
      stub_invalid_login
      expect(session.login('bad', 'credentials')).to eq 'Internal server error'
    end

    it 'makes a POST request to the login API' do
      err = double('err')
      response = double('response')
      allow(RestClient).to receive(:post).and_return(err, response)
      allow(session).to receive(:send_response)
      session.login('Mark', 'n3w5-f33d')
      expect(RestClient).to have_received(:post).with(
        'https://coolpay.herokuapp.com/api/login',
        "{\"username\":\"Mark\",\"apikey\":\"n3w5-f33d\"}",
        content_type: 'application/json'
      )
    end
  end

  describe '#add_recipient' do
    it 'calls the recipient class\'s #add method' do
      stub_valid_login
      stub_recipient_with_valid_auth_key
      recipient = double('recipient')
      allow(recipient).to receive(:add)
      allow(Recipient).to receive(:new).and_return(recipient)
      session.add_recipient('Jack')
      expect(recipient).to have_received(:add)
    end
  end
end
