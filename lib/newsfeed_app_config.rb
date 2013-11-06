require 'yaml'
class NewsfeedAppConfig
  class << self
    def [](config_key)
      @@app_settings ||= YAML::load_file("#{Rails.root}/config/settings.yml")[Rails.env]
      @@app_settings[config_key]
    end    
  end
end