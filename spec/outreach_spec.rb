require "spec_helper"

describe Outreach  do
  describe "#configure" do
    before do
      Outreach.configure do |config|
        config.client_id = "CLIENT_ID"
      end
    end

    it "returns the set value" do
      expect(Outreach.configuration.client_id).to eq "CLIENT_ID"
    end
  end
end