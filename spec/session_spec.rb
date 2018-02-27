require 'session'

describe Session do
  let(:session) { described_class.new }

  describe '#login' do
    it 'returns an authentication key' do
      stub_good_credentials
      session.login
      expect(session.auth_key).to eq '12345.yourtoken.67890'
    end

    it 'returns error response text when invalid credentials are supplied' do
      stub_bad_credentials
      expect(session.login('bad', 'credentials')).to eq 'Internal server error'
    end
  end
end
