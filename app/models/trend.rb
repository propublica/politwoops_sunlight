class Trend < ActiveRecord::Base
  before_save { |record| record.value = JSON.unparse(record.value) }
  after_save { |record| record.value = JSON.parse(record.value) }
  after_find { |record| record.value = JSON.parse(record.value) }
end
