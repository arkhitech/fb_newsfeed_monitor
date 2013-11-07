require 'yaml'
class NewsfeedAppConfig
  class << self
    def [](config_key)
      @@app_settings ||= YAML::load_file("#{Rails.root}/config/settings.yml")[Rails.env].symbolize_keys!
      @@app_settings[config_key].symbolize_keys!
    end    
  end
end