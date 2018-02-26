require 'session'

describe Session do
  before :each do
    Session.create
  end

  describe '#create' do
    it 'create a new instance of Session' do
      expect(Session.create).to be_an_instance_of Session
    end
  end

  describe '#access' do
    it 'returns an instance of Session' do
      expect(Session.access).to be_an_instance_of Session
    end
  end

  describe '#login' do
    it 'returns an authentication key' do
      stub_good_credentials
      Session.access.login
      expect(Session.access.auth_key).to eq '12345.yourtoken.67890'
    end

    it 'returns error response text when invalid credentials are supplied' do
      stub_bad_credentials
      expect(Session.access.login('bad', 'credentials')).to eq 'Internal server error'
    end
  end
end
