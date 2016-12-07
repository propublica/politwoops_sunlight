# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
map Politwoops::Application.config.try(:propub_url_root) || "/" do
  run Politwoops::Application
end
