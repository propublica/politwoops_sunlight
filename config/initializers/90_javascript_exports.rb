cfg = YAML.load_file "#{Rails.root}/config/config.yml"
JavascriptExports.export :sunlight_api_key, cfg[:sunlight_api_key]
