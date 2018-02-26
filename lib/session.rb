class Session
  def self.create
    @session = Session.new
  end

  def self.access
    @session
  end
end
