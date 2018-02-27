require 'payment'

describe Payment do
  let(:payment) { described_class.new }

  describe '#send' do
    it 'makes a POST request to the payments API' do
      allow(RestClient).to receive(:post)
      allow(payment).to receive(:get_id_by_name).and_return('12345')
      payment.send_to('Dr. Evil', 1_000_000, '42')
      expect(RestClient).to have_received(:post).with(
        'https://coolpay.herokuapp.com/api/payments',
        { payment: {
          amount: 1_000_000,
          currency: 'GBP',
          recipient_id: '12345'
        } },
        {
          content_type: 'application/json',
          authorization: 'Bearer 42'
        }
      )
    end

    it 'returns error response text when an invalid auth key is provided' do
      allow(payment).to receive(:get_id_by_name)
      stub_payment_with_invalid_auth_key
      expect(payment.send_to('Government Officials', 1_000_000, '5n34ky-br1b3')).to eq '401 Unauthorized'
    end
  end
end
