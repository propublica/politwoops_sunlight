class String
  def uncapitalize
    case self.length
    when 0 then self
    when 1 then self.downcase
    else [self.first.downcase, self.slice(1, self.length)].join
    end
  end
end

