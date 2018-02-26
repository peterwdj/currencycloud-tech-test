require 'session'

describe Session do
  describe '#create' do
    it 'create a new instance of Session' do
      expect(Session.create).to be_an_instance_of(Session)
    end
  end

  describe '#acces' do
    it 'returns an instance of Session' do
      expect(Session.access).to be_an_instance_of(Session)
    end
  end
end
