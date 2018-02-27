require 'recipient'

describe Recipient do
  let(:recipient) { described_class.new }

  describe '#add' do
    it 'makes a POST request to the recipients API' do
      allow(RestClient).to receive(:post)
      recipient.add('Marvin', '42')
      expect(RestClient).to have_received(:post).with(
        'https://coolpay.herokuapp.com/api/recipients', {:recipient=>{:name => "Marvin"}}, {:content_type=>"application/json", :authorization=>"Bearer 42"}
        )
    end

    it 'returns error response text when an invalid auth key is provided' do
      stub_request(:post, "https://coolpay.herokuapp.com/api/recipients").
        with(
          body: {
            'recipient': {
              'name': 'Marvin'
              }
            },
          headers: {
       	    :authorization => 'Bearer 42',
       	    :content_type => 'application/x-www-form-urlencoded',
          }
        ).to_return(
          status: 401,
          body: "401 Unauthorized"
        )
      expect(recipient.add('Marvin', '42')).to eq '401 Unauthorized'
    end
  end
end
