module Outreach
  class Configuration
    attr_accessor :client_id, :client_secret, :redirect_uri, :permissions

    def initialize
      @client_id = nil
      @client_secret = nil
      @redirect_uri = nil
      @permissions = []
    end
  end
end