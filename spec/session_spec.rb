require 'session'

describe Session do
  describe '#login' do
    it 'create a new instance of Session' do
      session = described_class.new
      expect(Session.create).to be_an_instance_of(Session)
    end
  end
end
