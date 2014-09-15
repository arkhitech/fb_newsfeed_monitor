class Linkedin < ActiveRecord::Base
  
  belongs_to :user
  after_save ThinkingSphinx::RealTime.callback_for(:linkedin)
  
end
