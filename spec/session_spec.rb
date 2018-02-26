require 'session'

describe Session do
  describe '#create' do
    it 'create a new instance of Session' do
      expect(Session.create).to be_an_instance_of(Session)
    end
  end

  describe '#access' do
    it 'returns an instance of Session' do
      expect(Session.access).to be_an_instance_of(Session)
    end
  end

  describe '#login' do
    it 'returns an authentication key' do
      stub_good_credentials
      session = Session.create
      session.login
      expect(session.auth_key).to eq '12345.yourtoken.67890'
    end

    it 'returns error response text when invalid credentials are supplied' do
      stub_bad_credentials
      session = Session.create
      expect(session.login('bad', 'credentials')).to eq 'Internal server error'
    end
  end
end
