class State

  def self.all
    Politician.select('DISTINCT(state)').where('state IS NOT NULL').map(&:state).sort
  end
end
