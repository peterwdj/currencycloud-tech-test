require 'payment'

describe Payment do
  let(:payment) { described_class.new }

  describe '#send' do
    it 'makes a POST request to the payments API' do
      allow(RestClient).to receive(:post)
      allow(payment).to receive(:get_id_by_name).and_return('12345')
      payment.send_to('Dr. Evil', 1000000, '42')
      expect(RestClient).to have_received(:post).with(
        'https://coolpay.herokuapp.com/api/payments',
        {:payment=>{
          :amount => 1000000,
          :currency => 'GBP',
          :recipient_id => '12345'
          }
        },
        {:content_type=>'application/json',
        :authorization=>'Bearer 42'}
      )
    end
  end
end
