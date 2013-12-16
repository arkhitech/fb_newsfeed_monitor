require 'spec_helper'

describe "SearchPhraseIntegerationsSpecs" do
  describe "GET /search_phrase_integerations_specs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get search_phrase_integerations_specs_path
      response.status.should be(200)
    end
  end
end
