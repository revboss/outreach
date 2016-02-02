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

    describe "authorize_url" do
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

    describe "initialize" do
      it "returns an Auth instance" do
        auth = Outreach::Auth.new "ACCESS_TOKEN", "REFRESH_TOKEN", (Time.now + 3600).to_s
        expect(auth.class).to be Outreach::Auth
      end

      it "sets tokens and expiration time" do
        auth = Outreach::Auth.new "ACCESS_TOKEN", "REFRESH_TOKEN", (Time.now + 3600).to_s

        expect(auth.access_token).to eq "ACCESS_TOKEN"
        expect(auth.refresh_token).to eq "REFRESH_TOKEN"
        expect(auth.expires).to_not be nil
      end

      it "sets the headers variable" do
        auth = Outreach::Auth.new "ACCESS_TOKEN", "REFRESH_TOKEN", (Time.now + 3600).to_s

        expect(auth.instance_variable_get(:@headers)['Authorization']).to eq "Bearer ACCESS_TOKEN"
      end
    end

    describe "authorize" do
      describe "successful response" do
        before do
          resp = double("response")
          allow(resp).to receive(:code).and_return(200)
          allow(resp).to receive(:parsed_response).and_return( {
            'access_token' => 'NEW_ACCESS_TOKEN',
            'refresh_token' => 'NEW_REFRESH_TOKEN',
            'created_at' => Time.now,
            'expires_in' => 7200
          } )
          expect(Outreach::Auth).to receive(:post).and_return(resp)
        end

        it "returns a Auth object" do
          auth = Outreach::Auth.authorize('CODE')
          expect(auth).to be_a_kind_of(Outreach::Auth)
        end
      end

      describe "failure response" do
        before do
          resp = double("response")
          allow(resp).to receive(:code).and_return(401)
          allow(resp).to receive(:message).and_return("test error")
          expect(Outreach::Auth).to receive(:post).and_return(resp)
        end

        it "raises an error" do
          expect {
            Outreach::Auth.authorize('CODE')
          }.to raise_error "Unexpected response for Outreach authorization (401): test error"
        end
      end
    end
  end
end