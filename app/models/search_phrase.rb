class SearchPhrase < ActiveRecord::Base
  
  validates :keyword, presence: true
#  validates :user_id, presence: true  [it needs to be checked after integration]
  
end
