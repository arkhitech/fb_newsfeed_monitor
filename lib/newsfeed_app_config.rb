require 'yaml'
class NewsfeedAppConfig
  class << self
    def [](config_key)
      @@app_settings ||= YAML::load_file("#{Rails.root}/config/settings.yml")[Rails.env].symbolize_keys!
      
      if @@app_settings[config_key] 
        @@app_settings[config_key].symbolize_keys!
      else
        puts "#{'*'*80}\nMissing config: #{config_key}\n#{@@app_settings}\n#{'*'*80}"
        nil
      end
    end    
  end
end