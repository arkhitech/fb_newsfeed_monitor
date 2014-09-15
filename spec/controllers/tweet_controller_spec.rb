require 'spec_helper'

describe TweetController do

  describe "GET 'tweet_feed'" do
    it "returns http success" do
      get 'tweet_feed'
      response.should be_success
    end
  end

  describe "GET 'tweet_search'" do
    it "returns http success" do
      get 'tweet_search'
      response.should be_success
    end
  end

end
