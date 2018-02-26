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
      RestClient = double('RestClient', :post => { :token => '12345.yourtoken.67890' }.to_json)
      session = Session.create
      session.login
      expect(session.auth_key).to eq '12345.yourtoken.67890'
    end
  end
end
