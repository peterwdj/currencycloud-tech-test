require 'session'
require 'recipient'
require 'payment'

describe Session do
  let(:session) { described_class.new }

  describe '#login' do
    it 'returns an authentication key' do
      stub_valid_login
      session.login
      expect(session.auth_token).to eq '12345.yourtoken.67890'
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
      stub_recipient_with_valid_auth_token
      recipient = double('recipient')
      allow(recipient).to receive(:add)
      allow(Recipient).to receive(:new).and_return(recipient)
      session.add_recipient('Jack')
      expect(recipient).to have_received(:add)
    end
  end

  describe '#make_payment' do
    it 'calls the payment class\'s #send_to method' do
      stub_valid_login
      stub_payment_with_valid_auth_token
      payment = double('payment')
      allow(payment).to receive(:send_to)
      allow(Payment).to receive(:new).and_return(payment)
      session.make_payment('Kevin', 1_000_000_000_000)
      expect(payment).to have_received(:send_to)
    end
  end

  describe '#verify_last_payment' do
    it 'calls the payment class\'s #verify method' do
      stub_valid_login
      payment = double('payment')
      allow(payment).to receive(:verify_payment)
      allow(Payment).to receive(:new).and_return(payment)
      session.verify_last_payment
      expect(payment).to have_received(:verify_payment)
    end
  end
end
