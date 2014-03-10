require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec/vcr_cassetes")
  c.hook_into :webmock
end
