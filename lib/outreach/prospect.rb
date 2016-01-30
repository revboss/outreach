module Outreach
  class Prospect < Auth
     def create(hash)
      options = {
        body: hash.to_json, 
        headers: @headers.merge( { 'Content-Type' => 'application/json' } )
      }

      response = self.class.post('/1.0/prospects', options)
      if response.code != 200
        raise "Unexpected response for Outreach prospect creation (#{response.code}): #{response.message} "
      end

      response.parsed_response['data']['id']
    end
  end
end