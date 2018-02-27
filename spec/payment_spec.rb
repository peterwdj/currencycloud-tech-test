require 'payment'

describe Payment do
  let(:payment) { described_class.new }

  describe '#send' do
    it 'makes a POST request to the payments API' do
      allow(RestClient).to receive(:post)
      allow(payment).to receive(:get_id_by_name).and_return('12345')
      payment.send_to('Dr. Evil', 1_000_000, 'dummy-key')
      expect(RestClient).to have_received(:post).with(
        'https://coolpay.herokuapp.com/api/payments',
        { payment: {
          amount: 1_000_000,
          currency: 'GBP',
          recipient_id: '12345'
        } },
        {
          content_type: 'application/json',
          authorization: 'Bearer dummy-key'
        }
      )
    end

    it 'returns error response text when an invalid auth key is provided' do
      allow(payment).to receive(:get_id_by_name).and_return('12345')
      stub_payment_with_invalid_auth_key
      expect(payment.send_to('Government Officials', 1_000_000, '5n34ky-br1b3')).to eq '401 Unauthorized'
    end

    it 'returns a prompt to create the recipient if the specified recipient does not exist' do
      allow(payment).to receive(:get_id_by_name).and_return(nil)
      expect(payment.send_to('My Future Self', 1000, 'wh4t-4-l0v31y-g1ft')).to eq 'Error: your selected recipient does not exist. Please add them as a recipient before attempting to send a payment to them.'
    end
  end

  describe '#verify' do
    it 'informs the user that the payment has been successful' do
      stub_successful_payment
      expect(payment.verify('g14nt-l4z3r')).to eq 'Your last payment was successful.'
    end

    it 'informs the user that the payment has been unsuccessful' do
      stub_unsuccessful_payment
      expect(payment.verify('g14nt-l4z3r')).to eq 'Your last payment was not successful. Please try again.'
    end
  end
end
