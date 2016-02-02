require "spec_helper"
require 'uri'

module Outreach
  describe Prospect do
    describe "#create" do
      before do
        @valid_hash = {
           data: {
            attributes: {
              company: {
                name: 'Test, Inc.',
                industry: 'Testing',
                size: '1-10 employees',
                locality: 'NC'
              },
              contact: {
                email: 'testuser@example.com',
                phone: {
                  work: '555-0287'
                }
              },
              personal: {
                name: {
                  first: 'Test',
                  last: 'User'
                },
                title: 'Tester'
              }
            }
          }
        }

        @prospect = Outreach::Prospect.new 'ACCESS_TOKEN', 'REFRESH_TOKEN', Time.now + 3600
      end

      describe "http error" do
        before do
          response = double('response')
          allow(response).to receive(:code) { 401 }
          allow(response).to receive(:message) { 'Test error' }
          expect(Outreach::Prospect).to receive(:post).once { response }
        end

        it "raises an error" do
          expect {
            @prospect.create @valid_hash
          }.to raise_error "Unexpected response for Outreach prospect creation (401): Test error"
        end
      end

      describe "error response" do
        before do
          response = double('response')
          allow(response).to receive(:code)  { 200 }
          allow(response).to receive(:parsed_response) {
            { 'errors' => [ { 'status' => '422', 'detail' => 'Test error.' } ] }
          }
          
          expect(Outreach::Prospect).to receive(:post).once { response }
        end

        it "raises an error" do
          expect {
            @prospect.create @valid_hash
          }.to raise_error "Error in Outreach prospect create (422): Test error."
        end
      end

      describe "http success" do
        before do
          response = double('response')
          allow(response).to receive(:code) { 200 }
          allow(response).to receive(:parsed_response) { { 'data' => { 'id' => '100' } } }

          expect(Outreach::Prospect).to receive(:post).once { response }
        end

        it "returns an id" do
          expect(@prospect.create(@valid_hash)).to eq '100'
        end
      end
    end
  end
end