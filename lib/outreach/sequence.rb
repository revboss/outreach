module Outreach
  class Sequence < Auth
    def query(page_number = 1, page_size = 50)
      query = {
        page: {
          number: page_number,
          size: [page_size, 50].min
        }
      }

      response = self.get('/1.0/sequences', query: query, headers: @headers)
      if response.code != 200
        raise "Unexpected response for Outreach sequence list (#{response.code}): #{response.message} "
      end

      response.parsed_response['data']
    end

    def add_prospects(sequence_id, *prospect_ids)
      query = {
        data: {
          relationships: {
            prospected: prospect_ids.map { |pid| { data: { id: pid } } }
          }
        }
      }

      response = self.patch("/1.0/sequences/#{sequence_id}", query: query, headers: @headers)
      if response.code != 200
        raise "Unexpected response for Outreach add prospect to sequence (#{response.code}): #{response.message} "
      end

      response.parsed_response['data']
    end
  end
end