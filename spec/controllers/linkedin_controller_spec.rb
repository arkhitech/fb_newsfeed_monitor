require 'spec_helper'

describe LinkedinController do

  describe "GET 'li_nw_updates'" do
    it "returns http success" do
      get 'li_nw_updates'
      response.should be_success
    end
  end

  describe "GET 'li_search'" do
    it "returns http success" do
      get 'li_search'
      response.should be_success
    end
  end

end
