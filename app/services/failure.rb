class Failure
  attr_reader :message

  def initialize (error=nil)
    if error.is_a? Exception
      @exception = error
      @message = error.to_s
    else
      @exception = nil
      @message = error
    end
  end

  def success?
    false
  end

  def to_s
    message.blank? and "Failed!" or "Failure: #{message}"
  end
end

