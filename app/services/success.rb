class Success
  attr_reader :message

  def initialize (msg=nil)
    @message = msg
  end

  def success?
    true
  end

  def to_s
    message.blank? and "Success!" or "Successfully #{message.uncapitalize}"
  end
end

