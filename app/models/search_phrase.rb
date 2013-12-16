class SearchPhrase < ActiveRecord::Base
  
  validates :keyword, :user_id, presence: true
  validates_uniqueness_of :keyword, :scope => :user_id
  belongs_to :user
    
end
