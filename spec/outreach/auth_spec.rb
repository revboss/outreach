require "spec_helper"
require 'uri'

module Outreach
  describe Auth do
    before(:all) do
      Outreach.configure do |config|
        config.client_id     = "client_id"
        config.client_secret = "client_secret"
        config.redirect_uri  = "http://localhost"
        config.permissions   = [
          Outreach::READ_SEQUENCES_PERMISSION,
          Outreach::CREATE_PROSPECTS_PERMISSION,
          Outreach::UPDATE_PROSPECTS_PERMISSION,
        ]
      end
    end

    describe "#authorize_url" do
      it "creates a url with config permissions" do
        url = Outreach::Auth.authorize_url
        
        expect(url).to match(/https:\/\/api.outreach.io\/oauth\/authorize/)
        expect(url).to match(/client_id=client_id/)
        expect(url).to match(/redirect_uri=#{URI.encode_www_form_component('http://localhost')}/)
        expect(url).to match(/scope=#{Regexp.quote(URI.encode_www_form_component(Outreach.configuration.permissions.join(" ")))}/)
      end

      it "creates a url with specified permissions" do
        url = Outreach::Auth.authorize_url(Outreach::READ_SEQUENCES_PERMISSION, Outreach::READ_TAGS_PERMISSION)
        
        expect(url).to match(/https:\/\/api.outreach.io\/oauth\/authorize/)
        expect(url).to match(/client_id=client_id/)
        expect(url).to match(/redirect_uri=#{URI.encode_www_form_component('http://localhost')}/)
        expect(url).to match(/scope=#{Regexp.quote(URI.encode_www_form_component([Outreach::READ_SEQUENCES_PERMISSION, Outreach::READ_TAGS_PERMISSION].join(" ")))}/)
      end
    end
  end
end