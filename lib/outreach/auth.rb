require 'httparty'

module Outreach
  class Auth
    include HTTParty

    base_uri 'https://api.outreach.io'

    attr_accessor :access_token, :refresh_token, :expires

    def initialize(access_token, refresh_token=nil, expires=nil)
      @access_token = access_token
      @refresh_token = refresh_token
      @expires = expires

      @headers = { "Authorization" => "Bearer #{@access_token}" }
    end

    def self.authorize_url(*permissions)
      permissions = permissions.empty? ? Outreach.configuration.permissions : permissions
      
      parameters = {
        client_id: Outreach.configuration.client_id,
        redirect_uri: Outreach.configuration.redirect_uri,
        response_type: 'code',
        scope: permissions.join(" ")
      }

      uri = URI.parse("#{self.base_uri}/oauth/authorize").tap do |uri|
        uri.query = URI.encode_www_form parameters
      end

      uri.to_s
    end

    def refresh
      query = {
        client_id: Outreach.configuration.client_id,
        client_secret: Outreach.configuration.client_secret,
        redirect_uri: Outreach.configuration.redirect_uri,
        grant_type: 'refresh_token',
        refresh_token: @refresh_token
      }

      response = self.post('/oauth/token', query: query)

      if response.code != 200
        raise "Unexpected response for Outreach token refresh (#{response.code}): #{response.message} "
      end

      @access_token = response.parsed_response['access_token']
      @refresh_token = response.parsed_response['refresh_token']
      @expires = response.parsed_response['expires']
    end

    def self.authorize(auth_code)
      query = {
        client_id: Outreach.configuration.client_id,
        client_secret: Outreach.configuration.client_secret,
        redirect_uri: Outreach.configuration.redirect_uri,
        grant_type: 'authorization_code',
        code: auth_code
      }

      response = self.post('/oauth/token', query: query)

      if response.code != 200
        raise "Unexpected response for Outreach authorization (#{response.code}): #{response.message}"
      end

      access_token = response.parsed_response['access_token']
      refresh_token = response.parsed_response['refresh_token']
      expires = response.parsed_response['expires']
      self.new access_token, refresh_token, expires
    end
  end
end