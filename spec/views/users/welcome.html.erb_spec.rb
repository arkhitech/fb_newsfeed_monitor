require "spec_helper"

describe "users/welcome.html.erb" do
  
  it "should render to partial 'layouts/login_page'" do
    view.stub(:render).with(hash_including(:partial => "formlayouts/login_page"))
  end  
  
end