require "spec_helper"

module Outreach
  describe Configuration do
    describe "#client_id" do
      it "has a nil default value" do
        expect(Configuration.new.client_id).to be nil
      end
    end

    describe "#client_id=" do
      it "can set value" do
        config = Configuration.new
        config.client_id = "CLIENT_ID"
        expect(config.client_id).to eq("CLIENT_ID")
      end
    end

    describe "#client_secret" do
      it "has a nil default value" do
        expect(Configuration.new.client_secret).to be nil
      end
    end

    describe "#client_secret=" do
      it "can set value" do
        config = Configuration.new
        config.client_secret = "CLIENT_SECRET"
        expect(config.client_secret).to eq("CLIENT_SECRET")
      end
    end

    describe "#redirect_uri" do
      it "has a nil default value" do
        expect(Configuration.new.redirect_uri).to be nil
      end
    end

    describe "#redirect_uri=" do
      it "can set value" do
        config = Configuration.new
        config.redirect_uri = "redirect uri"
        expect(config.redirect_uri).to eq("redirect uri")
      end
    end

    describe "#permissions" do
      it "has a nil default value" do
        expect(Configuration.new.permissions).to be_empty
      end
    end

    describe "#permissions=" do
      it "can set value" do
        config = Configuration.new
        config.permissions = ["permission"]
        expect(config.permissions).to eq ["permission"]
      end
    end
  end
end