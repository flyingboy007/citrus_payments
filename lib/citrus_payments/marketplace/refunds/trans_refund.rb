module CitrusPayments
  module Marketplace
    module Refunds
      class TransRefund
        def self.create(merchant_auth_token, refund_attributes)
          #check if all required fields are passed in
          [:trans_id, :refund_amount, :refund_ref, :pg_refund_charge, :refund_datetime].each do |arg|
            raise CitrusPayments::Errors::Input, ":#{arg} option required" if refund_attributes[arg].nil?
          end
          uri = URI.parse(CitrusPayments.configuration.base_url+'marketplace/trans/transrefund/')
          request = Net::HTTP::Post.new(uri)
          request.content_type = 'application/json'
          request['Auth_token']= merchant_auth_token
          request.body = JSON.dump(refund_attributes)

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
end