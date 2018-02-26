require 'recipient'

describe Recipient do
  describe '#add' do
    it 'makes a POST request to the recipients API' do
      allow(RestClient).to receive(:post)
      recipient = described_class.new
      recipient.add('Marvin', '42')
      expect(RestClient).to have_received(:post)
    end
  end
end
