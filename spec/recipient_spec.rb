require 'recipient'

describe Recipient do
  let(:recipient) { described_class.new }

  describe '#add' do
    it 'makes a POST request to the recipients API' do
      allow(RestClient).to receive(:post)
      recipient.add('Marvin', '42')
      expect(RestClient).to have_received(:post).with(
        'https://coolpay.herokuapp.com/api/recipients',
        { recipient: { name: 'Marvin' } },
        {
          content_type: 'application/json', authorization: 'Bearer 42'
        }
      )
    end

    it 'returns error response text when an invalid auth key is provided' do
      stub_recipient_with_invalid_auth_key
      expect(recipient.add('Marvin', '42')).to eq '401 Unauthorized'
    end
  end
end
