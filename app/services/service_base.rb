class ServiceBase
  def self.call(*args)
    new(*args).call
  end

  def self.call_safely(*args)
    begin
      new(*args).call
    rescue => e
      Failure.new(e)
    end
  end

  def success (msg)
    Success.new(msg)
  end

  def failure (err)
    Failure.new(err)
  end
end

