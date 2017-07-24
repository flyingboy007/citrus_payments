module CitrusPayments
  module Marketplace
    class Settlement

      #only needed in development
      #In production this is created by citrus
      #You don’t have to call this API on live environment as this is automatically supposed to Run before T+1 (5.00 pm) timeframe, where T is the day of transaction.
      #You can only release funds once settlement is successfully run.
      def self.create(auth_token, settlement_attributes)
        uri = URI.parse(CitrusPayments.configuration.base_url+'marketplace/pgsettlement/')
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        request['Auth_token']= auth_token
        request.body = JSON.dump(settlement_attributes)

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

      def self.get_status(auth_token, trans_id)
        uri = URI.parse(CitrusPayments.configuration.base_url+"marketplace/search/pgsettlement/#{trans_id}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri)
        request["cache-control"] = 'no-cache'
        request["auth_token"] = auth_token
        request["content-type"] = 'application/json'
        response = http.request(request)
        JSON.parse(response.body, :symbolize_names => true)
      end
    end
  end
end