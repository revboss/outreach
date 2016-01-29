module Outreach
  class Prospect < Auth
     def create(hash)
      options = {
        body: hash, 
        headers: @headers
      }

      response = self.class.post('/1.0/prospects', options)
      if response.code != 200
        raise "Unexpected response for Outreach prospect creation (#{response.code}): #{response.message} "
      end

      response.parsed_response['data']
    end
  end
end