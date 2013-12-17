require 'spec_helper'

describe "SearchPhrases" do
  describe "GET /search_phrases" do
   it "should have the content 'Welcome to Facebook Newsfeed Monitor'" do
      visit '/'
      expect(page).to have_content('Welcome to Facebook Newsfeed Monitor')
    end
  end
end
