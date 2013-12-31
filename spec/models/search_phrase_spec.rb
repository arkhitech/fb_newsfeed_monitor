require 'spec_helper'

class ValidatingWidget < ActiveRecord::Base
  self.table_name = :search_phrases
  validates_presence_of :keyword, :user_id
  validates_uniqueness_of :keyword, :scope => :user_id
end

describe SearchPhrase do

  SearchPhrase.destroy_all
  before :each do
    @search_phrase = SearchPhrase.new(keyword: "testkeyword",user_id: 1) #never hard code
    @search_phrase.save!
  end
  
  subject { @search_phrase }
  
  describe "when user_id is not present" do
    before {@search_phrase.update_attributes(user_id: "")}
    it {should_not be_valid}
  end
  
  describe "when keyword is not present" do
    before {@search_phrase.update_attributes(keyword: "")}
    it {should_not be_valid}
  end
  
  
  describe "when key word is duplicated for same user" do
    before {
      @search_phrase2=SearchPhrase.new(keyword: "testkeyword",user_id: @search_phrase.user_id) #never hard code
      @search_phrase2.save
    }
    it "Should fail validation" do
      expect(ValidatingWidget.new(keyword: "testkeyword",user_id: @search_phrase.user_id)).
                                                  to have(1).errors_on(:keyword)
    end

  end
  
  describe "when key word is duplicated for different user, it should validate" do
    before {
      @search_phrase3=SearchPhrase.new(keyword: "testkeyword",user_id: 2) #never hard code
      @search_phrase3.save
      
      puts "**************-->#{SearchPhrase.all.to_yaml}"
    }
        
    it "passes validation with same keyword used for different user" do
      expect(ValidatingWidget.new(keyword: "testkeyword",user_id: 3)).
        to have(0).errors_on(:keyword)
    end
  end
  
end