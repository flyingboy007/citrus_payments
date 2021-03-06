module CitrusPayments
  module Marketplace
    class Transaction
     #Release payment
      def self.release(auth_token, split_id)
        uri = URI.parse(CitrusPayments.configuration.base_url+'marketplace/funds/release/')
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        request['Auth_token']= auth_token
        request.body = JSON.dump({"split_id": split_id})

        req_options = {
            use_ssl: uri.scheme == 'https',
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        parsed_response=JSON.parse(response.body, :symbolize_names => true)
        #If input errors response will be in array in weird format
        if parsed_response.is_a?(Array)
          parsed_response.first[:property].slice!("instance.") #removes instance. string from response
          #making a response similar to other errors
          altered_response={error_id: "7", error_category: "stack", error_description: parsed_response.first[:property]+" "+parsed_response.first[:message]}
        else
          parsed_response
        end
      end

    end
  end
end